import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/donation_camp_model.dart';
import 'user_repository.dart';

part 'donation_camp_repository.g.dart';

typedef DonationCampEntry = ({String id, DonationCampModel camp});

class DonationCampPermissionDenied implements Exception {
  DonationCampPermissionDenied(this.adminUid);

  final String adminUid;

  @override
  String toString() =>
      'DonationCampPermissionDenied: user $adminUid is not an admin';
}

class DonationCampRepository {
  DonationCampRepository(
    FirebaseFirestore firestore,
    UserRepository userRepository,
  ) : _userRepository = userRepository,
      _camps = firestore
          .collection('donationCamps')
          .withConverter<DonationCampModel>(
            fromFirestore: (snapshot, _) =>
                DonationCampModel.fromJson(snapshot.data()!),
            toFirestore: (camp, _) => camp.toJson(),
          ),
      _rawCamps = firestore.collection('donationCamps');

  final UserRepository _userRepository;
  final CollectionReference<DonationCampModel> _camps;
  final CollectionReference<Map<String, dynamic>> _rawCamps;

  CollectionReference<CampRsvpModel> _rsvpCollection(String campId) {
    return _rawCamps
        .doc(campId)
        .collection('rsvps')
        .withConverter<CampRsvpModel>(
          fromFirestore: (snapshot, _) =>
              CampRsvpModel.fromJson(snapshot.data()!),
          toFirestore: (rsvp, _) => rsvp.toJson(),
        );
  }

  Future<void> _requireAdmin(String adminUid) async {
    final user = await _userRepository.getUser(adminUid);
    if (user == null || !user.roles.contains('admin')) {
      throw DonationCampPermissionDenied(adminUid);
    }
  }

  Future<List<DonationCampEntry>> listUpcomingCamps({DateTime? now}) async {
    final effectiveNow = now ?? DateTime.now();
    final snapshot = await _camps
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(effectiveNow))
        .orderBy('date')
        .get();
    return snapshot.docs.map((doc) => (id: doc.id, camp: doc.data())).toList();
  }

  // Admin management needs to see/edit past camps too, unlike the consumer
  // listing above which only shows upcoming ones.
  Future<List<DonationCampEntry>> listAllCamps() async {
    final snapshot = await _camps.orderBy('date', descending: true).get();
    return snapshot.docs.map((doc) => (id: doc.id, camp: doc.data())).toList();
  }

  Future<DonationCampModel?> getCamp(String id) async {
    final snapshot = await _camps.doc(id).get();
    return snapshot.data();
  }

  Future<String> createCamp(DonationCampModel camp, String adminUid) async {
    await _requireAdmin(adminUid);
    final doc = _rawCamps.doc();
    await doc.set({
      ...camp.toJson(),
      'createdBy': adminUid,
      'updatedBy': adminUid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updateCamp(
    String id,
    DonationCampModel camp,
    String adminUid,
  ) async {
    await _requireAdmin(adminUid);
    await _rawCamps.doc(id).set({
      ...camp.toJson(),
      'updatedBy': adminUid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rsvp(String campId, String uid) async {
    await _rawCamps.doc(campId).collection('rsvps').doc(uid).set({
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> cancelRsvp(String campId, String uid) async {
    await _rsvpCollection(campId).doc(uid).delete();
  }

  Stream<bool> watchRsvpStatus(String campId, String uid) {
    return _rsvpCollection(
      campId,
    ).doc(uid).snapshots().map((snapshot) => snapshot.exists);
  }

  // Watches the rsvps subcollection directly rather than
  // `.count().snapshots()` — fake_cloud_firestore (used in tests) doesn't
  // implement realtime aggregate queries, only one-shot `.count().get()`.
  Stream<int> watchRsvpCount(String campId) {
    return _rsvpCollection(campId).snapshots().map((s) => s.docs.length);
  }

  Future<int> rsvpCount(String campId) async {
    final snapshot = await _rawCamps
        .doc(campId)
        .collection('rsvps')
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}

@Riverpod(keepAlive: true)
DonationCampRepository donationCampRepository(Ref ref) {
  return DonationCampRepository(
    FirebaseFirestore.instance,
    ref.watch(userRepositoryProvider),
  );
}
