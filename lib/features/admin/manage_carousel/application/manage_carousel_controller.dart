import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/banner_item_model.dart';
import '../../../../data/repositories/banner_item_repository.dart';

part 'manage_carousel_controller.g.dart';

@riverpod
class ManageCarouselController extends _$ManageCarouselController {
  @override
  Future<List<({String id, BannerItemModel model})>> build() {
    return ref.read(bannerItemRepositoryProvider).listAllBanners();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  String _requireAdminUid() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError(
        'No signed-in admin — cannot attribute this banner write.',
      );
    }
    return uid;
  }

  Future<void> toggleActive(String id, bool active) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final adminUid = _requireAdminUid();
      final repo = ref.read(bannerItemRepositoryProvider);
      await repo.setActive(id, active, adminUid);
      return repo.listAllBanners();
    });
  }

  Future<void> moveUp(String id) => _swap(id, offset: -1);

  Future<void> moveDown(String id) => _swap(id, offset: 1);

  Future<void> _swap(String id, {required int offset}) async {
    final current = state.value;
    if (current == null) return;
    final index = current.indexWhere((record) => record.id == id);
    final neighborIndex = index + offset;
    if (index == -1 || neighborIndex < 0 || neighborIndex >= current.length) {
      return;
    }

    final a = current[index];
    final b = current[neighborIndex];

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final adminUid = _requireAdminUid();
      final repo = ref.read(bannerItemRepositoryProvider);
      await repo.setDisplayOrder(a.id, b.model.displayOrder, adminUid);
      await repo.setDisplayOrder(b.id, a.model.displayOrder, adminUid);
      return repo.listAllBanners();
    });
  }
}
