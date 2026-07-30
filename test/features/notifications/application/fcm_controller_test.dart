import 'package:bloodlink/core/router/auth_state.dart';
import 'package:bloodlink/data/models/user_model.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:bloodlink/features/notifications/application/fcm_controller.dart';
import 'package:bloodlink/features/notifications/application/fcm_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _authorizedSettings = NotificationSettings(
  alert: AppleNotificationSetting.notSupported,
  announcement: AppleNotificationSetting.notSupported,
  authorizationStatus: AuthorizationStatus.authorized,
  badge: AppleNotificationSetting.notSupported,
  carPlay: AppleNotificationSetting.notSupported,
  lockScreen: AppleNotificationSetting.notSupported,
  notificationCenter: AppleNotificationSetting.notSupported,
  showPreviews: AppleShowPreviewSetting.notSupported,
  timeSensitive: AppleNotificationSetting.notSupported,
  criticalAlert: AppleNotificationSetting.notSupported,
  sound: AppleNotificationSetting.notSupported,
  providesAppNotificationSettings: AppleNotificationSetting.notSupported,
);

const _deniedSettings = NotificationSettings(
  alert: AppleNotificationSetting.notSupported,
  announcement: AppleNotificationSetting.notSupported,
  authorizationStatus: AuthorizationStatus.denied,
  badge: AppleNotificationSetting.notSupported,
  carPlay: AppleNotificationSetting.notSupported,
  lockScreen: AppleNotificationSetting.notSupported,
  notificationCenter: AppleNotificationSetting.notSupported,
  showPreviews: AppleShowPreviewSetting.notSupported,
  timeSensitive: AppleNotificationSetting.notSupported,
  criticalAlert: AppleNotificationSetting.notSupported,
  sound: AppleNotificationSetting.notSupported,
  providesAppNotificationSettings: AppleNotificationSetting.notSupported,
);

class _FakeFcmService implements FcmService {
  _FakeFcmService({required this.notificationSettings});

  final NotificationSettings notificationSettings;
  final String? token = 'fake-token';

  @override
  Future<NotificationSettings> requestPermission() async =>
      notificationSettings;

  @override
  Future<NotificationSettings> getNotificationSettings() async =>
      notificationSettings;

  @override
  Future<String?> getToken() async => token;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMessage => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMessageOpenedApp => const Stream.empty();

  @override
  Future<RemoteMessage?> getInitialMessage() async => null;
}

class _FakeUserRepository implements UserRepository {
  String? updatedUid;
  String? updatedToken;
  var updateFcmTokenCallCount = 0;

  @override
  Future<void> updateFcmToken(String uid, String token) async {
    updatedUid = uid;
    updatedToken = token;
    updateFcmTokenCallCount++;
  }

  @override
  Future<UserModel?> getUser(String uid) async => null;

  @override
  Future<void> createUser(String uid, UserModel user) async {}

  @override
  Future<void> updateRoles(String uid, List<String> roles) async {}

  @override
  Future<void> updateLocation(
    String uid, {
    GeoPoint? location,
    String? city,
  }) async {}

  @override
  Stream<UserModel?> watchUser(String uid) => const Stream.empty();
}

void main() {
  group('FcmController returning-user re-registration', () {
    test(
      'already signed in with permission already granted stores a token without being prompted',
      () async {
        final fakeUserRepo = _FakeUserRepository();
        final container = ProviderContainer(
          overrides: [
            authStateProvider.overrideWithValue(
              const AuthState.signedIn(uid: 'u1', roles: ['donor']),
            ),
            fcmServiceProvider.overrideWithValue(
              _FakeFcmService(notificationSettings: _authorizedSettings),
            ),
            userRepositoryProvider.overrideWithValue(fakeUserRepo),
          ],
        );
        addTearDown(container.dispose);

        container.read(fcmControllerProvider);
        await pumpEventQueue();

        expect(fakeUserRepo.updateFcmTokenCallCount, 1);
        expect(fakeUserRepo.updatedUid, 'u1');
        expect(fakeUserRepo.updatedToken, 'fake-token');
      },
    );

    test(
      'already signed in but permission not granted stores nothing',
      () async {
        final fakeUserRepo = _FakeUserRepository();
        final container = ProviderContainer(
          overrides: [
            authStateProvider.overrideWithValue(
              const AuthState.signedIn(uid: 'u1', roles: ['donor']),
            ),
            fcmServiceProvider.overrideWithValue(
              _FakeFcmService(notificationSettings: _deniedSettings),
            ),
            userRepositoryProvider.overrideWithValue(fakeUserRepo),
          ],
        );
        addTearDown(container.dispose);

        container.read(fcmControllerProvider);
        await pumpEventQueue();

        expect(fakeUserRepo.updateFcmTokenCallCount, 0);
      },
    );

    test('signed out at boot stores nothing', () async {
      final fakeUserRepo = _FakeUserRepository();
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(const AuthState.signedOut()),
          fcmServiceProvider.overrideWithValue(
            _FakeFcmService(notificationSettings: _authorizedSettings),
          ),
          userRepositoryProvider.overrideWithValue(fakeUserRepo),
        ],
      );
      addTearDown(container.dispose);

      container.read(fcmControllerProvider);
      await pumpEventQueue();

      expect(fakeUserRepo.updateFcmTokenCallCount, 0);
    });
  });
}
