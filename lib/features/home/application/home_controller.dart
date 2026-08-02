import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/auth_state.dart';
import '../../../data/models/banner_item_model.dart';
import '../../../data/models/partner_model.dart';
import '../../../data/repositories/banner_item_repository.dart';
import '../../../data/repositories/blood_request_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/partner_repository.dart';
import '../../../data/repositories/user_repository.dart';

part 'home_controller.g.dart';

const _pendingNearbyRadiusMeters = 50000.0;
const _trustedPartnersLimit = 6;

enum HomeLocationStatus { resolving, available, unavailable }

typedef HomeState = ({
  List<({String id, BannerItemModel model})> banners,
  List<({String id, PartnerModel partner})> trustedPartners,
  int? pendingNearbyCount,
  HomeLocationStatus locationStatus,
});

@riverpod
class HomeController extends _$HomeController {
  @override
  Future<HomeState> build() async {
    final bannersFuture = ref
        .read(bannerItemRepositoryProvider)
        .listActiveBanners();
    final partnersFuture = ref
        .read(partnerRepositoryProvider)
        .listPartners(verifiedOnly: true);
    final banners = await bannersFuture;
    final partners = await partnersFuture;

    // "Recently verified" is approximated by updatedAt (last-edited time) —
    // PartnerModel has no dedicated verification timestamp, so any admin
    // edit (address fix, phone change, etc.) bumps a partner the same as an
    // actual verification-status change would. Accepted simplification.
    final trustedPartners = [...partners]
      ..sort((a, b) => b.partner.updatedAt.compareTo(a.partner.updatedAt));

    unawaited(_resolvePendingNearby());

    return (
      banners: banners,
      trustedPartners: trustedPartners.take(_trustedPartnersLimit).toList(),
      pendingNearbyCount: null,
      locationStatus: HomeLocationStatus.resolving,
    );
  }

  Future<void> _resolvePendingNearby() async {
    final center = await _resolveCenter();
    if (!ref.mounted) return;
    final current = state.value;
    if (current == null) return;

    if (center == null) {
      state = AsyncData((
        banners: current.banners,
        trustedPartners: current.trustedPartners,
        pendingNearbyCount: null,
        locationStatus: HomeLocationStatus.unavailable,
      ));
      return;
    }

    final count = await ref
        .read(bloodRequestRepositoryProvider)
        .countPendingNear(center, _pendingNearbyRadiusMeters);

    if (!ref.mounted) return;
    final latest = state.value;
    if (latest == null) return;
    state = AsyncData((
      banners: latest.banners,
      trustedPartners: latest.trustedPartners,
      pendingNearbyCount: count,
      locationStatus: HomeLocationStatus.available,
    ));
  }

  Future<GeoPoint?> _resolveCenter() async {
    final position = await _requestPosition();
    if (position != null) {
      return GeoPoint(position.latitude, position.longitude);
    }

    // Falls back to the user's stored profile location (device-location
    // capture or manual city entry from donor profile setup) when live
    // location isn't available — see UserRepository.updateLocation.
    final uid = ref.read(authStateProvider).uid;
    if (uid == null) return null;
    final user = await ref.read(userRepositoryProvider).getUser(uid);
    return user?.location;
  }

  Future<Position?> _requestPosition() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled ||
          permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
Stream<int> unreadNotificationCount(Ref ref) {
  final uid = ref.watch(authStateProvider).uid;
  if (uid == null) return Stream.value(0);
  return ref.watch(notificationRepositoryProvider).watchUnreadCount(uid);
}
