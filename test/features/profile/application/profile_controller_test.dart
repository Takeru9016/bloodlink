import 'package:bloodlink/core/router/auth_state.dart';
import 'package:bloodlink/data/models/donor_profile_model.dart';
import 'package:bloodlink/data/models/user_model.dart';
import 'package:bloodlink/data/repositories/donor_profile_repository.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:bloodlink/features/profile/application/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

UserModel _user() => UserModel(
  name: 'Asha Rao',
  email: 'asha@example.com',
  roles: const ['donor'],
  createdAt: Timestamp.now(),
);

DonorProfileModel _profile() => DonorProfileModel(
  bloodGroup: BloodGroup.oPositive,
  dob: Timestamp.fromDate(DateTime(1995, 1, 1)),
  verificationStatus: VerificationStatus.verified,
  optInRadiusKm: 10,
);

class _FakeUserRepository implements UserRepository {
  _FakeUserRepository(this.user);

  final UserModel? user;

  @override
  Future<UserModel?> getUser(String uid) async => user;

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

class _FakeDonorProfileRepository implements DonorProfileRepository {
  _FakeDonorProfileRepository(this.profile);

  final DonorProfileModel? profile;
  var getProfileCallCount = 0;

  @override
  Future<DonorProfileModel?> getProfile(String uid) async {
    getProfileCallCount++;
    return profile;
  }

  @override
  Future<void> createOrUpdateProfile(String uid, DonorProfileModel profile) async {}

  @override
  Stream<DonorProfileModel?> watchProfile(String uid) => const Stream.empty();

  @override
  Future<void> updateOptInRadius(String uid, double radiusKm) async {}

  @override
  Future<List<({String id, DonorProfileModel profile})>> queryVerifiedDonors({
    required String bloodGroup,
    GeoPoint? near,
    double? radiusKm,
  }) async => [];

  @override
  Future<String> uploadVerificationDoc(String uid, dynamic file) async => '';

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
  group('ProfileController.build', () {
    test('donor role fetches the donor profile alongside the user doc', () async {
      final fakeDonorRepo = _FakeDonorProfileRepository(_profile());
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(
            const AuthState.signedIn(uid: 'u1', roles: ['donor']),
          ),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository(_user())),
          donorProfileRepositoryProvider.overrideWithValue(fakeDonorRepo),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(profileControllerProvider.future);

      expect(state.isDonor, isTrue);
      expect(state.user.name, 'Asha Rao');
      expect(state.donorProfile, isNotNull);
      expect(fakeDonorRepo.getProfileCallCount, 1);
    });

    test('requester-only role never fetches a donor profile', () async {
      final fakeDonorRepo = _FakeDonorProfileRepository(_profile());
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(
            const AuthState.signedIn(uid: 'u1', roles: ['requester']),
          ),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository(_user())),
          donorProfileRepositoryProvider.overrideWithValue(fakeDonorRepo),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(profileControllerProvider.future);

      expect(state.isDonor, isFalse);
      expect(state.donorProfile, isNull);
      expect(fakeDonorRepo.getProfileCallCount, 0);
    });

    test('missing user doc throws — a real invariant violation, not a normal state', () async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(
            const AuthState.signedIn(uid: 'ghost', roles: ['donor']),
          ),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository(null)),
          donorProfileRepositoryProvider.overrideWithValue(
            _FakeDonorProfileRepository(null),
          ),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(profileControllerProvider.future),
        throwsA(isA<StateError>()),
      );
    });
  });
}
