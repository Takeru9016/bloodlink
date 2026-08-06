import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/help_faq_model.dart';
import 'user_repository.dart';

part 'help_faq_repository.g.dart';

class HelpFaqPermissionDenied implements Exception {
  HelpFaqPermissionDenied(this.adminUid);

  final String adminUid;

  @override
  String toString() =>
      'HelpFaqPermissionDenied: user $adminUid is not an admin';
}

class HelpFaqRepository {
  HelpFaqRepository(FirebaseFirestore firestore, UserRepository userRepository)
    : _userRepository = userRepository,
      _faqs = firestore
          .collection('helpFaqs')
          .withConverter<HelpFaqModel>(
            fromFirestore: (snapshot, _) =>
                HelpFaqModel.fromJson(snapshot.data()!),
            toFirestore: (faq, _) => faq.toJson(),
          ),
      _rawFaqs = firestore.collection('helpFaqs');

  final UserRepository _userRepository;
  final CollectionReference<HelpFaqModel> _faqs;
  final CollectionReference<Map<String, dynamic>> _rawFaqs;

  Future<void> _requireAdmin(String adminUid) async {
    final user = await _userRepository.getUser(adminUid);
    if (user == null || !user.roles.contains('admin')) {
      throw HelpFaqPermissionDenied(adminUid);
    }
  }

  Future<HelpFaqModel?> getFaq(String id) async {
    final snapshot = await _faqs.doc(id).get();
    return snapshot.data();
  }

  // Sorts client-side rather than chaining .orderBy, same tradeoff as
  // EducationArticleRepository.listArticles — a small collection, no need
  // for a Firestore-side sort/index.
  Future<List<({String id, HelpFaqModel model})>> listFaqs() async {
    final snapshot = await _faqs.get();
    final results = snapshot.docs
        .map((doc) => (id: doc.id, model: doc.data()))
        .toList();
    results.sort(
      (a, b) => a.model.displayOrder.compareTo(b.model.displayOrder),
    );
    return results;
  }

  Future<String> createFaq(HelpFaqModel faq, String adminUid) async {
    await _requireAdmin(adminUid);
    final doc = _rawFaqs.doc();
    await doc.set({
      ...faq.toJson(),
      'updatedBy': adminUid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updateFaq(String id, HelpFaqModel faq, String adminUid) async {
    await _requireAdmin(adminUid);
    await _rawFaqs.doc(id).set({
      ...faq.toJson(),
      'updatedBy': adminUid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteFaq(String id, String adminUid) async {
    await _requireAdmin(adminUid);
    await _rawFaqs.doc(id).delete();
  }
}

@Riverpod(keepAlive: true)
HelpFaqRepository helpFaqRepository(Ref ref) {
  return HelpFaqRepository(
    FirebaseFirestore.instance,
    ref.watch(userRepositoryProvider),
  );
}
