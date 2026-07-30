import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_service.g.dart';

/// Thin wrapper around [FirebaseMessaging.instance] so [FcmController] can be
/// unit-tested against a fake instead of the real plugin's platform channels.
abstract class FcmService {
  Future<NotificationSettings> requestPermission();
  Future<NotificationSettings> getNotificationSettings();
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
  Stream<RemoteMessage> get onMessage;
  Stream<RemoteMessage> get onMessageOpenedApp;
  Future<RemoteMessage?> getInitialMessage();
}

class FirebaseFcmService implements FcmService {
  @override
  Future<NotificationSettings> requestPermission() =>
      FirebaseMessaging.instance.requestPermission();

  @override
  Future<NotificationSettings> getNotificationSettings() =>
      FirebaseMessaging.instance.getNotificationSettings();

  @override
  Future<String?> getToken() => FirebaseMessaging.instance.getToken();

  @override
  Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<RemoteMessage?> getInitialMessage() =>
      FirebaseMessaging.instance.getInitialMessage();
}

@Riverpod(keepAlive: true)
FcmService fcmService(Ref ref) => FirebaseFcmService();
