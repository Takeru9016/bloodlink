import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/donor_profile_model.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

part 'donor_profile_repository.g.dart';

const _verifiedQueryLimit = 50;
const _knownBloodGroups = {'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'};

class DonorPermissionDenied implements Exception {
  DonorPermissionDenied(this.adminUid);

  final String adminUid;

  @override
  String toString() => 'DonorPermissionDenied: user $adminUid is not an admin';
}

class DonorProfileRepository {
  DonorProfileRepository(
    FirebaseFirestore firestore,
    FirebaseStorage storage,
    UserRepository userRepository,
  ) : _firestore = firestore,
      _storage = storage,
      _userRepository = userRepository,
      _donorProfiles = firestore
          .collection('donorProfiles')
          .withConverter<DonorProfileModel>(
            fromFirestore: (snapshot, _) =>
                DonorProfileModel.fromJson(snapshot.data()!),
            toFirestore: (profile, _) => profile.toJson(),
          );

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final UserRepository _userRepository;
  final CollectionReference<DonorProfileModel> _donorProfiles;

  Future<void> _requireAdmin(String adminUid) async {
    final user = await _userRepository.getUser(adminUid);
    if (user == null || !user.roles.contains('admin')) {
      throw DonorPermissionDenied(adminUid);
    }
  }

  Future<DonorProfileModel?> getProfile(String uid) async {
    final snapshot = await _donorProfiles.doc(uid).get();
    return snapshot.data();
  }

  Future<void> createOrUpdateProfile(String uid, DonorProfileModel profile) {
    return _donorProfiles.doc(uid).set(profile);
  }

  Stream<DonorProfileModel?> watchProfile(String uid) {
    return _donorProfiles
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  Future<List<({String id, DonorProfileModel profile})>> queryVerifiedDonors({
    required String bloodGroup,
    GeoPoint? near,
    double? radiusKm,
  }) async {
    assert(
      _knownBloodGroups.contains(bloodGroup),
      'bloodGroup must be a raw Firestore value (e.g. "A+"), not a BloodGroup enum name: $bloodGroup',
    );

    final snapshot = await _donorProfiles
        .where('bloodGroup', isEqualTo: bloodGroup)
        .where('verificationStatus', isEqualTo: 'verified')
        .limit(_verifiedQueryLimit)
        .get();

    if (near == null || radiusKm == null) {
      return snapshot.docs
          .map((doc) => (id: doc.id, profile: doc.data()))
          .toList();
    }

    final uids = snapshot.docs.map((doc) => doc.id).toList();
    final userDocs = await Future.wait(
      uids.map((uid) => _firestore.collection('users').doc(uid).get()),
    );

    final uidsWithinRadius = <String>{};
    for (final userDoc in userDocs) {
      final user = userDoc.data();
      if (user == null) continue;
      final location = UserModel.fromJson(user).location;
      if (location == null) continue;
      final distanceKm =
          Geolocator.distanceBetween(
            near.latitude,
            near.longitude,
            location.latitude,
            location.longitude,
          ) /
          1000;
      if (distanceKm <= radiusKm) {
        uidsWithinRadius.add(userDoc.id);
      }
    }

    return snapshot.docs
        .where((doc) => uidsWithinRadius.contains(doc.id))
        .map((doc) => (id: doc.id, profile: doc.data()))
        .toList();
  }

  /// Uploads to a fixed per-user path — a resubmission overwrites the same
  /// Storage object rather than accumulating new ones. Firebase reuses the
  /// same download token across overwrites of a path, so the base URL from
  /// [getDownloadURL] alone is identical before and after a resubmission;
  /// without a cache-busting suffix, Image.network (keyed by URL string) can
  /// keep rendering the previous photo's cached bytes even though Firestore
  /// and Storage both hold the new one. The extra query param is ignored by
  /// Storage's download endpoint but forces callers to treat this as a new
  /// URL, which is what actually makes re-submission visible.
  Future<String> uploadVerificationDoc(String uid, File file) async {
    final ref = _storage.ref('donorVerification/$uid/id_document.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    final url = await ref.getDownloadURL();
    return '$url&uploadedAt=${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Records a new ID submission. Always resets [verificationStatus] to
  /// "pending" — including when re-uploading after a rejection or to
  /// replace an already-verified ID — so a stale status never survives a
  /// fresh submission.
  Future<void> submitVerification(String uid, String docUrl) {
    return _donorProfiles.doc(uid).update({
      'verificationDocUrl': docUrl,
      'verificationStatus': 'pending',
    });
  }

  /// Live query so the admin review queue reflects a donor's resubmission
  /// immediately, rather than requiring a manual refresh of a cached list.
  Stream<List<({String id, DonorProfileModel profile})>> watchPendingDonors() {
    return _donorProfiles
        .where('verificationStatus', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => (id: doc.id, profile: doc.data()))
              .toList(),
        );
  }

  Future<void> setVerificationStatus(
    String uid,
    VerificationStatus status,
    String adminUid,
  ) async {
    await _requireAdmin(adminUid);
    await _donorProfiles.doc(uid).update({
      'verificationStatus': _verificationStatusJson[status],
      'verifiedBy': adminUid,
      'verifiedAt': FieldValue.serverTimestamp(),
    });
  }
}

const _verificationStatusJson = {
  VerificationStatus.unverified: 'unverified',
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
};

@Riverpod(keepAlive: true)
DonorProfileRepository donorProfileRepository(Ref ref) {
  return DonorProfileRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
    ref.watch(userRepositoryProvider),
  );
}
