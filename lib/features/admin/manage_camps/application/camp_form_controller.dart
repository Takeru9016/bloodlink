import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/donation_camp_model.dart';
import '../../../../data/repositories/donation_camp_repository.dart';

part 'camp_form_controller.g.dart';

@riverpod
Future<DonationCampModel?> campById(Ref ref, String campId) {
  return ref.read(donationCampRepositoryProvider).getCamp(campId);
}

@riverpod
class CampFormController extends _$CampFormController {
  @override
  FutureOr<void> build() {}

  /// Creates or updates the camp and returns its doc id, or null if the
  /// write failed (the error is left on [state] for the screen to surface).
  Future<String?> submit({
    required String? campId,
    required DonationCampModel camp,
  }) async {
    state = const AsyncLoading();
    String? resultId = campId;
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw StateError(
          'No signed-in admin — cannot attribute this camp write.',
        );
      }
      final adminUid = firebaseUser.uid;
      final repo = ref.read(donationCampRepositoryProvider);
      if (campId == null) {
        resultId = await repo.createCamp(camp, adminUid);
      } else {
        await repo.updateCamp(campId, camp, adminUid);
      }
    });
    return state.hasError ? null : resultId;
  }
}
