import 'dart:io';

import 'package:bloodlink/data/models/donor_profile_model.dart';
import 'package:bloodlink/data/models/user_model.dart';
import 'package:bloodlink/data/repositories/donor_profile_repository.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:bloodlink/features/donor_directory/application/donor_directory_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

DonorProfileModel _profile() => DonorProfileModel(
  bloodGroup: BloodGroup.oPositive,
  dob: Timestamp.fromDate(DateTime(1995, 1, 1)),
  verificationStatus: VerificationStatus.verified,
  optInRadiusKm: 10,
);

class _FakeDonorProfileRepository implements DonorProfileRepository {
  _FakeDonorProfileRepository(this.results);

  final List<({String id, DonorProfileModel profile})> results;
  String? lastBloodGroupQueried;
  var queryCallCount = 0;

  @override
  Future<List<({String id, DonorProfileModel profile})>> queryVerifiedDonors({
    required String bloodGroup,
    GeoPoint? near,
    double? radiusKm,
  }) async {
    lastBloodGroupQueried = bloodGroup;
    queryCallCount++;
    return results;
  }

  @override
  Future<DonorProfileModel?> getProfile(String uid) async => null;

  @override
  Future<void> createOrUpdateProfile(String uid, DonorProfileModel profile) async {}

  @override
  Stream<DonorProfileModel?> watchProfile(String uid) => const Stream.empty();

  @override
  Future<void> updateOptInRadius(String uid, double radiusKm) async {}

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

class _FakeUserRepository implements UserRepository {
  _FakeUserRepository(this.users);

  final Map<String, UserModel> users;

  @override
  Future<UserModel?> getUser(String uid) async => users[uid];

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
  }) async {}

  @override
  Future<void> updateLocation(
    String uid, {
    GeoPoint? location,
    String? city,
  }) async {}

  @override
  Stream<UserModel?> watchUser(String uid) => const Stream.empty();
}

UserModel _user(String name) => UserModel(
  name: name,
  email: '$name@example.com',
  roles: const ['donor'],
  createdAt: Timestamp.now(),
);

void main() {
  group('DonorDirectoryController.setBloodGroup', () {
    test('queries with the selected blood group and maps donor names', () async {
      final fakeDonorRepo = _FakeDonorProfileRepository([
        (id: 'd1', profile: _profile()),
        (id: 'd2', profile: _profile()),
      ]);
      final fakeUserRepo = _FakeUserRepository({
        'd1': _user('Asha'),
        'd2': _user('Bala'),
      });
      final container = ProviderContainer(
        overrides: [
          donorProfileRepositoryProvider.overrideWithValue(fakeDonorRepo),
          userRepositoryProvider.overrideWithValue(fakeUserRepo),
        ],
      );
      addTearDown(container.dispose);

      // No geolocator platform channel in a unit test, so position
      // resolution always fails and is swallowed by the controller's own
      // try/catch — this exercises the "location unavailable" path, which
      // is itself a real, reachable app state (permission denied/no GPS).
      await container.read(donorDirectoryControllerProvider.future);
      await container
          .read(donorDirectoryControllerProvider.notifier)
          .setBloodGroup('O+');

      final state = container.read(donorDirectoryControllerProvider).value!;
      expect(fakeDonorRepo.lastBloodGroupQueried, 'O+');
      expect(state.bloodGroup, 'O+');
      expect(state.entries, hasLength(2));
      expect(state.entries.map((e) => e.name), containsAll(['Asha', 'Bala']));
      expect(state.locationStatus, DonorDirectoryLocationStatus.unavailable);
    });

    test('unknown user id falls back to "Unknown donor"', () async {
      final fakeDonorRepo = _FakeDonorProfileRepository([
        (id: 'ghost', profile: _profile()),
      ]);
      final container = ProviderContainer(
        overrides: [
          donorProfileRepositoryProvider.overrideWithValue(fakeDonorRepo),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository({})),
        ],
      );
      addTearDown(container.dispose);

      await container.read(donorDirectoryControllerProvider.future);
      await container
          .read(donorDirectoryControllerProvider.notifier)
          .setBloodGroup('AB-');

      final state = container.read(donorDirectoryControllerProvider).value!;
      expect(state.entries.single.name, 'Unknown donor');
    });
  });

  group('DonorDirectoryController.setRadiusKm', () {
    test('re-runs the query when a blood group is already selected', () async {
      final fakeDonorRepo = _FakeDonorProfileRepository([]);
      final container = ProviderContainer(
        overrides: [
          donorProfileRepositoryProvider.overrideWithValue(fakeDonorRepo),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository({})),
        ],
      );
      addTearDown(container.dispose);

      await container.read(donorDirectoryControllerProvider.future);
      await container
          .read(donorDirectoryControllerProvider.notifier)
          .setBloodGroup('B+');
      expect(fakeDonorRepo.queryCallCount, 1);

      await container
          .read(donorDirectoryControllerProvider.notifier)
          .setRadiusKm(25);
      expect(fakeDonorRepo.queryCallCount, 2);
    });

    test('with no blood group selected yet, just stores the radius', () async {
      final fakeDonorRepo = _FakeDonorProfileRepository([]);
      final container = ProviderContainer(
        overrides: [
          donorProfileRepositoryProvider.overrideWithValue(fakeDonorRepo),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository({})),
        ],
      );
      addTearDown(container.dispose);

      await container.read(donorDirectoryControllerProvider.future);
      await container
          .read(donorDirectoryControllerProvider.notifier)
          .setRadiusKm(10);

      expect(fakeDonorRepo.queryCallCount, 0);
      final state = container.read(donorDirectoryControllerProvider).value!;
      expect(state.radiusKm, 10);
      expect(state.bloodGroup, isNull);
    });
  });
}
