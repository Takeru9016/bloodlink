import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/donor_profile_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/donor_profile_repository.dart';
import '../../../../data/repositories/user_repository.dart';

part 'verify_donors_controller.g.dart';

/// Live — reflects a donor's resubmission (or a fresh pending entry)
/// immediately, so the queue never shows a cached/first-submitted photo.
@riverpod
Stream<List<({String id, DonorProfileModel profile})>> pendingDonors(Ref ref) {
  return ref.read(donorProfileRepositoryProvider).watchPendingDonors();
}

@riverpod
Future<UserModel?> donorUser(Ref ref, String uid) {
  return ref.read(userRepositoryProvider).getUser(uid);
}

@riverpod
class VerifyDonorsController extends _$VerifyDonorsController {
  @override
  FutureOr<void> build() {}

  Future<void> _setStatus(String uid, VerificationStatus status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final adminUid = FirebaseAuth.instance.currentUser?.uid;
      if (adminUid == null) {
        throw StateError('No signed-in admin — cannot attribute this write.');
      }
      await ref
          .read(donorProfileRepositoryProvider)
          .setVerificationStatus(uid, status, adminUid);
    });
  }

  Future<void> approve(String uid) =>
      _setStatus(uid, VerificationStatus.verified);

  Future<void> reject(String uid) =>
      _setStatus(uid, VerificationStatus.unverified);
}
