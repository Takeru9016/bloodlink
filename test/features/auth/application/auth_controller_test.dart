import 'package:bloodlink/core/auth/firebase_auth_provider.dart';
import 'package:bloodlink/data/models/user_model.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:bloodlink/features/auth/application/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

class _FakeUserRepository implements UserRepository {
  String? createdUid;
  UserModel? createdUser;
  var createUserCallCount = 0;

  @override
  Future<void> createUser(String uid, UserModel user) async {
    createdUid = uid;
    createdUser = user;
    createUserCallCount++;
  }

  @override
  Future<UserModel?> getUser(String uid) async => null;

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

void main() {
  group('AuthController.signUp', () {
    test('creates the Firebase Auth user and the Firestore user doc', () async {
      final mockAuth = MockFirebaseAuth();
      final fakeUserRepo = _FakeUserRepository();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          userRepositoryProvider.overrideWithValue(fakeUserRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authControllerProvider.notifier)
          .signUp(name: 'Asha Rao', email: 'asha@example.com', password: 'hunter22');

      final state = container.read(authControllerProvider);
      expect(state.hasError, isFalse);
      expect(mockAuth.currentUser, isNotNull);
      expect(fakeUserRepo.createUserCallCount, 1);
      expect(fakeUserRepo.createdUid, mockAuth.currentUser!.uid);
      expect(fakeUserRepo.createdUser!.name, 'Asha Rao');
      expect(fakeUserRepo.createdUser!.email, 'asha@example.com');
      expect(fakeUserRepo.createdUser!.roles, isEmpty);
    });

    test('a failed Auth call surfaces as AsyncError and never touches Firestore', () async {
      final mockAuth = MockFirebaseAuth();
      whenCalling(
        Invocation.method(#createUserWithEmailAndPassword, null, {
          #email: 'taken@example.com',
          #password: 'hunter22',
        }),
      ).on(mockAuth).thenThrow(
        FirebaseAuthException(code: 'email-already-in-use'),
      );
      final fakeUserRepo = _FakeUserRepository();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          userRepositoryProvider.overrideWithValue(fakeUserRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authControllerProvider.notifier)
          .signUp(
            name: 'Asha Rao',
            email: 'taken@example.com',
            password: 'hunter22',
          );

      final state = container.read(authControllerProvider);
      expect(state.hasError, isTrue);
      expect(
        (state.error as FirebaseAuthException).code,
        'email-already-in-use',
      );
      expect(fakeUserRepo.createUserCallCount, 0);
    });
  });

  group('AuthController.signIn', () {
    test('a successful sign-in resolves without error', () async {
      final mockAuth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'u1', email: 'asha@example.com'),
      );
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authControllerProvider.notifier)
          .signIn(email: 'asha@example.com', password: 'hunter22');

      expect(container.read(authControllerProvider).hasError, isFalse);
    });

    test('wrong-password surfaces as AsyncError', () async {
      final mockAuth = MockFirebaseAuth();
      whenCalling(
        Invocation.method(#signInWithEmailAndPassword, null, {
          #email: 'asha@example.com',
          #password: 'wrong',
        }),
      ).on(mockAuth).thenThrow(FirebaseAuthException(code: 'wrong-password'));
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authControllerProvider.notifier)
          .signIn(email: 'asha@example.com', password: 'wrong');

      final state = container.read(authControllerProvider);
      expect(state.hasError, isTrue);
      expect((state.error as FirebaseAuthException).code, 'wrong-password');
    });
  });
}
