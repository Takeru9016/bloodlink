import 'dart:io';

import 'package:bloodlink/core/router/auth_state.dart';
import 'package:bloodlink/data/models/donor_profile_model.dart';
import 'package:bloodlink/data/models/user_model.dart';
import 'package:bloodlink/data/repositories/donor_profile_repository.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:bloodlink/features/notifications/application/fcm_service.dart';
import 'package:bloodlink/features/profile/application/settings_controller.dart';
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
  _FakeFcmService(this.notificationSettings);

  final NotificationSettings notificationSettings;

  @override
  Future<NotificationSettings> requestPermission() async =>
      notificationSettings;

  @override
  Future<NotificationSettings> getNotificationSettings() async =>
      notificationSettings;

  @override
  Future<String?> getToken() async => 'fake-token';

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMessage => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMessageOpenedApp => const Stream.empty();

  @override
  Future<RemoteMessage?> getInitialMessage() async => null;
}

UserModel _user() => UserModel(
  name: 'Asha Rao',
  email: 'asha@example.com',
  roles: const ['donor'],
  createdAt: Timestamp.now(),
);

class _FakeUserRepository implements UserRepository {
  String? updatedUid;
  String? updatedName;
  String? updatedPhone;
  var updateProfileCallCount = 0;

  @override
  Future<UserModel?> getUser(String uid) async => _user();

  @override
  Future<void> createUser(String uid, UserModel user) async {}

  @override
  Future<void> updateRoles(String uid, List<String> roles) async {}

  @override
  Future<void> updateFcmToken(String uid, String token) async {}

  @override
  Future<void> updateProfile(
    String uid, {
    required String name,
    String? phone,
  }) async {
    updatedUid = uid;
    updatedName = name;
    updatedPhone = phone;
    updateProfileCallCount++;
  }

  @override
  Future<void> updateLocation(
    String uid, {
    GeoPoint? location,
    String? city,
  }) async {}

  @override
  Stream<UserModel?> watchUser(String uid) => const Stream.empty();
}

class _FakeDonorProfileRepository implements DonorProfileRepository {
  String? updatedUid;
  double? updatedRadiusKm;
  var updateOptInRadiusCallCount = 0;

  @override
  Future<void> updateOptInRadius(String uid, double radiusKm) async {
    updatedUid = uid;
    updatedRadiusKm = radiusKm;
    updateOptInRadiusCallCount++;
  }

  @override
  Future<DonorProfileModel?> getProfile(String uid) async => null;

  @override
  Future<void> createOrUpdateProfile(String uid, DonorProfileModel profile) async {}

  @override
  Stream<DonorProfileModel?> watchProfile(String uid) => const Stream.empty();

  @override
  Future<List<({String id, DonorProfileModel profile})>> queryVerifiedDonors({
    required String bloodGroup,
    GeoPoint? near,
    double? radiusKm,
  }) async => [];

  @override
  Future<String> uploadVerificationDoc(String uid, File file) async => '';

  @override
  Future<void> submitVerification(String uid, String docUrl) async {}

  @override
  Future<void> setVerificationStatus(
    String uid,
    VerificationStatus status,
    String adminUid,
  ) async {}

  @override
  Stream<List<({String id, DonorProfileModel profile})>> watchPendingDonors() =>
      const Stream.empty();
}

void main() {
  group('SettingsController.build', () {
    test('composes profile state with the current push-permission status', () async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(
            const AuthState.signedIn(uid: 'u1', roles: ['donor']),
          ),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
          donorProfileRepositoryProvider.overrideWithValue(
            _FakeDonorProfileRepository(),
          ),
          fcmServiceProvider.overrideWithValue(
            _FakeFcmService(_authorizedSettings),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(settingsControllerProvider.future);

      expect(state.pushEnabled, isTrue);
      expect(state.profile.user.name, 'Asha Rao');
    });

    test('denied notification permission reports pushEnabled false', () async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(
            const AuthState.signedIn(uid: 'u1', roles: ['donor']),
          ),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
          donorProfileRepositoryProvider.overrideWithValue(
            _FakeDonorProfileRepository(),
          ),
          fcmServiceProvider.overrideWithValue(
            _FakeFcmService(_deniedSettings),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(settingsControllerProvider.future);

      expect(state.pushEnabled, isFalse);
    });
  });

  group('SettingsController.saveAccountInfo', () {
    test('writes name/phone through the user repository', () async {
      final fakeUserRepo = _FakeUserRepository();
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(
            const AuthState.signedIn(uid: 'u1', roles: ['donor']),
          ),
          userRepositoryProvider.overrideWithValue(fakeUserRepo),
          donorProfileRepositoryProvider.overrideWithValue(
            _FakeDonorProfileRepository(),
          ),
          fcmServiceProvider.overrideWithValue(
            _FakeFcmService(_authorizedSettings),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(settingsControllerProvider.future);
      await container
          .read(settingsControllerProvider.notifier)
          .saveAccountInfo(name: 'New Name', phone: '+15551234567');

      expect(fakeUserRepo.updateProfileCallCount, 1);
      expect(fakeUserRepo.updatedUid, 'u1');
      expect(fakeUserRepo.updatedName, 'New Name');
      expect(fakeUserRepo.updatedPhone, '+15551234567');
      expect(container.read(settingsControllerProvider).hasError, isFalse);
    });
  });

  group('SettingsController.updateOptInRadius', () {
    test('writes the radius through the donor profile repository', () async {
      final fakeDonorRepo = _FakeDonorProfileRepository();
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(
            const AuthState.signedIn(uid: 'u1', roles: ['donor']),
          ),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
          donorProfileRepositoryProvider.overrideWithValue(fakeDonorRepo),
          fcmServiceProvider.overrideWithValue(
            _FakeFcmService(_authorizedSettings),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(settingsControllerProvider.future);
      await container
          .read(settingsControllerProvider.notifier)
          .updateOptInRadius(15);

      expect(fakeDonorRepo.updateOptInRadiusCallCount, 1);
      expect(fakeDonorRepo.updatedUid, 'u1');
      expect(fakeDonorRepo.updatedRadiusKm, 15);
    });
  });
}
