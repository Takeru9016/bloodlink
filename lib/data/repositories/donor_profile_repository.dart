import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/donor_profile_model.dart';
import '../models/user_model.dart';

part 'donor_profile_repository.g.dart';

const _verifiedQueryLimit = 50;
const _knownBloodGroups = {'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'};

class DonorProfileRepository {
  DonorProfileRepository(FirebaseFirestore firestore)
    : _firestore = firestore,
      _donorProfiles = firestore
          .collection('donorProfiles')
          .withConverter<DonorProfileModel>(
            fromFirestore: (snapshot, _) =>
                DonorProfileModel.fromJson(snapshot.data()!),
            toFirestore: (profile, _) => profile.toJson(),
          );

  final FirebaseFirestore _firestore;
  final CollectionReference<DonorProfileModel> _donorProfiles;

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

  Future<List<DonorProfileModel>> queryVerifiedDonors({
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
      return snapshot.docs.map((doc) => doc.data()).toList();
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
        .map((doc) => doc.data())
        .toList();
  }
}

@Riverpod(keepAlive: true)
DonorProfileRepository donorProfileRepository(Ref ref) {
  return DonorProfileRepository(FirebaseFirestore.instance);
}
