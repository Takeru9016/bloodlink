import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/auth_state.dart';
import '../../../data/models/donor_profile_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/donor_profile_repository.dart';
import '../../../data/repositories/user_repository.dart';

part 'profile_controller.g.dart';

typedef ProfileState = ({
  UserModel user,
  bool isDonor,
  DonorProfileModel? donorProfile,
});

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<ProfileState> build() async {
    final authState = ref.watch(authStateProvider);
    final uid = authState.uid;
    if (uid == null) {
      // Signing out flips authStateProvider to signedOut, which rebuilds
      // this provider while `_redirect` (app_router.dart) is mid-navigation
      // away from Profile. Throwing here would flash "Failed to load
      // profile" for a frame; staying pending until the screen is disposed
      // is the same tradeoff myDonorProfileProvider makes for the same race.
      return Completer<ProfileState>().future;
    }

    final user = await ref.read(userRepositoryProvider).getUser(uid);
    if (user == null) {
      throw StateError('User document not found for $uid.');
    }

    final isDonor = authState.roles.contains('donor');
    // Only fetched for donor-role users — DonorProfileModel only exists at
    // donorProfiles/{uid} once donor onboarding has been completed.
    final donorProfile = isDonor
        ? await ref.read(donorProfileRepositoryProvider).getProfile(uid)
        : null;

    return (user: user, isDonor: isDonor, donorProfile: donorProfile);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
