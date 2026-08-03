import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/donor_profile_model.dart';
import '../../../data/repositories/donor_profile_repository.dart';
import '../../../data/repositories/user_repository.dart';

part 'donor_profile_setup_controller.g.dart';

// Placeholder until Profile/Settings exposes opt-in radius as an editable field.
const _defaultOptInRadiusKm = 15.0;

// NOT keepAlive, unlike AuthController/RequestStatusController/FcmController/
// NotificationCenterController: submit()/skip() write `roles`, which flips
// authStateProvider same as those controllers' triggers do, but
// app_router.dart's `_redirect` explicitly exempts this screen's own path
// from the roles-empty redirect (`auth.roles.isEmpty && path !=
// donorProfileSetupPath`), so the roles write can never unmount this
// screen's own watcher mid-call. If that exemption is ever removed, this
// needs the same @Riverpod(keepAlive: true) fix as the other four.
@riverpod
class DonorProfileSetupController extends _$DonorProfileSetupController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required BloodGroup bloodGroup,
    required DateTime dob,
    DateTime? lastDonationDate,
    GeoPoint? location,
    String? city,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw StateError('No signed-in user');
      final userRepo = ref.read(userRepositoryProvider);

      await ref
          .read(donorProfileRepositoryProvider)
          .createOrUpdateProfile(
            uid,
            DonorProfileModel(
              bloodGroup: bloodGroup,
              dob: Timestamp.fromDate(dob),
              lastDonationDate: lastDonationDate == null
                  ? null
                  : Timestamp.fromDate(lastDonationDate),
              verificationStatus: VerificationStatus.unverified,
              optInRadiusKm: _defaultOptInRadiusKm,
            ),
          );

      if (location != null || city != null) {
        await userRepo.updateLocation(uid, location: location, city: city);
      }

      final currentUser = await userRepo.getUser(uid);
      final roles = {...?currentUser?.roles, 'donor'}.toList();
      await userRepo.updateRoles(uid, roles);
    });
  }

  Future<void> skip() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw StateError('No signed-in user');
      final userRepo = ref.read(userRepositoryProvider);
      final currentUser = await userRepo.getUser(uid);
      final roles = {...?currentUser?.roles, 'requester'}.toList();
      await userRepo.updateRoles(uid, roles);
    });
  }
}
