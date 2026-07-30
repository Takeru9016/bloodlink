import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/auth_state.dart';
import '../../../data/repositories/user_repository.dart';
import 'fcm_service.dart';

part 'fcm_controller.g.dart';

bool _isGranted(AuthorizationStatus status) =>
    status == AuthorizationStatus.authorized ||
    status == AuthorizationStatus.provisional;

@Riverpod(keepAlive: true)
class FcmController extends _$FcmController {
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _openedAppSub;

  @override
  FutureOr<void> build() {
    ref.onDispose(() {
      _tokenRefreshSub?.cancel();
      _foregroundSub?.cancel();
      _openedAppSub?.cancel();
    });

    final service = ref.read(fcmServiceProvider);

    _tokenRefreshSub = service.onTokenRefresh.listen(_storeToken);
    _foregroundSub = service.onMessage.listen(_showForegroundBanner);
    _openedAppSub = service.onMessageOpenedApp.listen(_handleNotificationTap);

    service.getInitialMessage().then((message) {
      if (message != null) _handleNotificationTap(message);
    }, onError: (_) {});

    // Donor profile setup is the only place that *prompts* for permission.
    // A returning user who is already authorized (re-signing in on a new
    // device, or after a reinstall) would otherwise never get a token
    // stored, since onTokenRefresh only fires on rotation.
    ref.listen(authStateProvider, (previous, next) {
      if (next.isSignedIn && previous?.uid != next.uid) {
        unawaited(_registerIfAlreadyAuthorized());
      }
    });
    if (ref.read(authStateProvider).isSignedIn) {
      unawaited(_registerIfAlreadyAuthorized());
    }
  }

  Future<void> requestPermissionAndRegister() async {
    final service = ref.read(fcmServiceProvider);
    final settings = await service.requestPermission();
    if (!_isGranted(settings.authorizationStatus)) return;

    final token = await service.getToken();
    if (token != null) await _storeToken(token);
  }

  Future<void> _registerIfAlreadyAuthorized() async {
    final service = ref.read(fcmServiceProvider);
    final settings = await service.getNotificationSettings();
    if (!_isGranted(settings.authorizationStatus)) return;

    final token = await service.getToken();
    if (token != null) await _storeToken(token);
  }

  Future<void> _storeToken(String token) async {
    final uid = ref.read(authStateProvider).uid;
    if (uid == null) return;
    await ref.read(userRepositoryProvider).updateFcmToken(uid, token);
  }

  void _showForegroundBanner(RemoteMessage message) {
    final title = message.notification?.title;
    final body = message.notification?.body;
    if (title == null && body == null) return;

    final context = ref
        .read(appRouterProvider)
        .routerDelegate
        .navigatorKey
        .currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text([title, body].whereType<String>().join(' — '))),
    );
  }

  // The payload's `type` field will route to a specific screen once
  // notification types are defined — for now every tap just opens home.
  void _handleNotificationTap(RemoteMessage message) {
    ref.read(appRouterProvider).goNamed(AppRoute.homeName);
  }
}
