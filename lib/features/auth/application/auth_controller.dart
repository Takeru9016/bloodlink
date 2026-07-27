import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  final _googleSignIn = GoogleSignIn.instance;
  bool _googleSignInInitialized = false;

  @override
  FutureOr<void> build() {}

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await _googleSignIn.initialize();
    _googleSignInInitialized = true;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = credential.user!.uid;
      await ref
          .read(userRepositoryProvider)
          .createUser(
            uid,
            UserModel(
              name: name,
              email: email,
              roles: const [],
              location: const GeoPoint(0, 0),
              createdAt: Timestamp.now(),
            ),
          );
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await _ensureGoogleSignInInitialized();
      final account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user!;

      final repo = ref.read(userRepositoryProvider);
      if (await repo.getUser(user.uid) == null) {
        await repo.createUser(
          user.uid,
          UserModel(
            name: user.displayName ?? '',
            email: user.email ?? '',
            roles: const [],
            location: const GeoPoint(0, 0),
            createdAt: Timestamp.now(),
          ),
        );
      }
      state = const AsyncData(null);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        state = const AsyncData(null);
        return;
      }
      state = AsyncError(e, StackTrace.current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
    });
  }
}
