import 'package:bloodlink/data/models/donor_profile_model.dart';
import 'package:bloodlink/data/repositories/donor_profile_repository.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';

// This test only exercises Firestore reads. A hand-rolled fake (rather than a
// mock package) keeps the dev-dependency footprint to fake_cloud_firestore
// alone — any accidental Storage call fails loudly instead of silently
// hitting a real bucket.
class _UnusedFirebaseStorage implements FirebaseStorage {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    'queryVerifiedDonors must not touch Cloud Storage',
  );
}

Map<String, dynamic> _profileJson({
  required String bloodGroup,
  required String verificationStatus,
}) {
  return {
    'bloodGroup': bloodGroup,
    'dob': Timestamp.fromDate(DateTime(1995, 1, 1)),
    'lastDonationDate': null,
    'verificationStatus': verificationStatus,
    'optInRadiusKm': 15.0,
    'verificationDocUrl': null,
    'verifiedBy': null,
    'verifiedAt': null,
  };
}

void main() {
  test('1A-11 regression: queryVerifiedDonors excludes pending and rejected '
      'donors now that 2A-8 produces real pending/unverified data', () async {
    final firestore = FakeFirebaseFirestore();

    // "pending-1" mirrors submitVerification's write; "rejected-1" mirrors
    // setVerificationStatus's write after an admin rejects (status goes
    // back to "unverified", not a dedicated "rejected" state).
    await firestore
        .collection('donorProfiles')
        .doc('verified-1')
        .set(_profileJson(bloodGroup: 'O+', verificationStatus: 'verified'));
    await firestore
        .collection('donorProfiles')
        .doc('pending-1')
        .set(_profileJson(bloodGroup: 'O+', verificationStatus: 'pending'));
    await firestore
        .collection('donorProfiles')
        .doc('rejected-1')
        .set(_profileJson(bloodGroup: 'O+', verificationStatus: 'unverified'));
    // Different blood group entirely — should never surface regardless of
    // status, sanity-checks the bloodGroup filter isn't accidentally
    // dropped by the changes in this task.
    await firestore
        .collection('donorProfiles')
        .doc('verified-wrong-group')
        .set(_profileJson(bloodGroup: 'A-', verificationStatus: 'verified'));

    final repo = DonorProfileRepository(
      firestore,
      _UnusedFirebaseStorage(),
      UserRepository(firestore),
    );

    final results = await repo.queryVerifiedDonors(bloodGroup: 'O+');

    expect(results, hasLength(1));
    expect(results.single.id, 'verified-1');
    expect(
      results.single.profile.verificationStatus,
      VerificationStatus.verified,
    );
  });
}
