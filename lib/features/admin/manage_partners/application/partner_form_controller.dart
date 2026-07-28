import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/partner_model.dart';
import '../../../../data/repositories/partner_repository.dart';

part 'partner_form_controller.g.dart';

@riverpod
Future<PartnerModel?> partnerById(Ref ref, String partnerId) {
  return ref.read(partnerRepositoryProvider).getPartner(partnerId);
}

@riverpod
class PartnerFormController extends _$PartnerFormController {
  @override
  FutureOr<void> build() {}

  /// Creates or updates the partner and returns its doc id, or null if the
  /// write failed (the error is left on [state] for the screen to surface).
  Future<String?> submit({
    required String? partnerId,
    required PartnerModel partner,
  }) async {
    state = const AsyncLoading();
    String? resultId = partnerId;
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw StateError(
          'No signed-in admin — cannot attribute this partner write.',
        );
      }
      final adminUid = firebaseUser.uid;
      final repo = ref.read(partnerRepositoryProvider);
      if (partnerId == null) {
        resultId = await repo.createPartner(partner, adminUid);
      } else {
        await repo.updatePartner(partnerId, partner, adminUid);
      }
    });
    return state.hasError ? null : resultId;
  }
}
