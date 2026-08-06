import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/auth_state.dart';
import '../../../data/repositories/donor_profile_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../notifications/application/fcm_controller.dart';
import '../../notifications/application/fcm_service.dart';
import 'profile_controller.dart';

part 'settings_controller.g.dart';

typedef SettingsState = ({ProfileState profile, bool pushEnabled});

bool _isGranted(AuthorizationStatus status) =>
    status == AuthorizationStatus.authorized ||
    status == AuthorizationStatus.provisional;

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<SettingsState> build() async {
    final profile = await ref.watch(profileControllerProvider.future);
    final settings = await ref
        .read(fcmServiceProvider)
        .getNotificationSettings();
    return (
      profile: profile,
      pushEnabled: _isGranted(settings.authorizationStatus),
    );
  }

  Future<void> saveAccountInfo({required String name, String? phone}) async {
    final uid = ref.read(authStateProvider).uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(userRepositoryProvider)
          .updateProfile(uid, name: name, phone: phone);
      ref.invalidate(profileControllerProvider);
      return build();
    });
  }

  Future<void> updateOptInRadius(double radiusKm) async {
    final uid = ref.read(authStateProvider).uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(donorProfileRepositoryProvider)
          .updateOptInRadius(uid, radiusKm);
      ref.invalidate(profileControllerProvider);
      return build();
    });
  }

  Future<void> requestPushPermission() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(fcmControllerProvider.notifier)
          .requestPermissionAndRegister();
      return build();
    });
  }
}
