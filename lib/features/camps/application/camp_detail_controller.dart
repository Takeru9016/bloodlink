import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/donation_camp_model.dart';
import '../../../data/repositories/donation_camp_repository.dart';

part 'camp_detail_controller.g.dart';

@riverpod
Future<DonationCampModel?> campDetail(Ref ref, String campId) {
  return ref.read(donationCampRepositoryProvider).getCamp(campId);
}

@riverpod
Stream<int> campRsvpCount(Ref ref, String campId) {
  return ref.read(donationCampRepositoryProvider).watchRsvpCount(campId);
}

@riverpod
Stream<bool> campRsvpStatus(Ref ref, String campId) {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    return Stream.value(false);
  }
  return ref
      .read(donationCampRepositoryProvider)
      .watchRsvpStatus(campId, firebaseUser.uid);
}

@riverpod
class CampRsvpController extends _$CampRsvpController {
  @override
  FutureOr<void> build() {}

  Future<bool> toggle({required String campId, required bool isRsvped}) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      throw StateError('No signed-in user — cannot RSVP.');
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(donationCampRepositoryProvider);
      if (isRsvped) {
        await repository.cancelRsvp(campId, firebaseUser.uid);
      } else {
        await repository.rsvp(campId, firebaseUser.uid);
      }
    });

    return !state.hasError;
  }
}
