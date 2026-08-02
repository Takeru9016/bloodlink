import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/banner_item_model.dart';
import '../../../../data/models/partner_model.dart';
import '../../../../data/repositories/banner_item_repository.dart';
import '../../../../data/repositories/partner_repository.dart';

part 'upload_banner_controller.g.dart';

@riverpod
Future<List<({String id, PartnerModel partner})>> partnersForBannerLink(
  Ref ref,
) {
  return ref.read(partnerRepositoryProvider).listPartners();
}

@riverpod
class UploadBannerController extends _$UploadBannerController {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({
    required File image,
    required String? linkedPartnerId,
    required int displayOrder,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final adminUid = FirebaseAuth.instance.currentUser?.uid;
      if (adminUid == null) {
        throw StateError(
          'No signed-in admin — cannot attribute this banner write.',
        );
      }
      final repo = ref.read(bannerItemRepositoryProvider);
      final imageUrl = await repo.uploadBannerImage(image);
      final banner = BannerItemModel(
        imageUrl: imageUrl,
        linkedPartnerId: linkedPartnerId,
        displayOrder: displayOrder,
        active: true,
        // Overwritten by BannerItemRepository with the acting admin's
        // uid/server timestamp — this placeholder is never persisted as-is.
        createdBy: '',
        updatedAt: Timestamp.now(),
      );
      await repo.createBanner(banner, adminUid);
    });
    return !state.hasError;
  }
}
