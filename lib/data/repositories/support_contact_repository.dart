import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/support_contact_model.dart';
import 'user_repository.dart';

part 'support_contact_repository.g.dart';

class SupportContactPermissionDenied implements Exception {
  SupportContactPermissionDenied(this.adminUid);

  final String adminUid;

  @override
  String toString() =>
      'SupportContactPermissionDenied: user $adminUid is not an admin';
}

// Singleton doc at appConfig/support — not a collection, since there's only
// ever one support contact for the whole app.
class SupportContactRepository {
  SupportContactRepository(
    FirebaseFirestore firestore,
    UserRepository userRepository,
  ) : _userRepository = userRepository,
      _doc = firestore
          .collection('appConfig')
          .doc('support')
          .withConverter<SupportContactModel>(
            fromFirestore: (snapshot, _) =>
                SupportContactModel.fromJson(snapshot.data()!),
            toFirestore: (contact, _) => contact.toJson(),
          ),
      _rawDoc = firestore.collection('appConfig').doc('support');

  final UserRepository _userRepository;
  final DocumentReference<SupportContactModel> _doc;
  final DocumentReference<Map<String, dynamic>> _rawDoc;

  Future<void> _requireAdmin(String adminUid) async {
    final user = await _userRepository.getUser(adminUid);
    if (user == null || !user.roles.contains('admin')) {
      throw SupportContactPermissionDenied(adminUid);
    }
  }

  // Returns null if no admin has set a support contact yet — callers must
  // show an honest "not set yet" state rather than falling back to a
  // hardcoded default.
  Future<SupportContactModel?> getSupportContact() async {
    final snapshot = await _doc.get();
    return snapshot.data();
  }

  Future<void> updateSupportContact(String email, String adminUid) async {
    await _requireAdmin(adminUid);
    await _rawDoc.set({
      'email': email,
      'updatedBy': adminUid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

@Riverpod(keepAlive: true)
SupportContactRepository supportContactRepository(Ref ref) {
  return SupportContactRepository(
    FirebaseFirestore.instance,
    ref.watch(userRepositoryProvider),
  );
}
