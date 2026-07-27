import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/user_repository.dart';

part 'auth_state.g.dart';

enum AuthStatus { loading, signedOut, signedIn }

/// Minimal shape the router needs to make redirect decisions.
class AuthState {
  const AuthState._({required this.status, this.uid, this.roles = const []});

  const AuthState.loading() : this._(status: AuthStatus.loading);

  const AuthState.signedOut() : this._(status: AuthStatus.signedOut);

  const AuthState.signedIn({required String uid, required List<String> roles})
    : this._(status: AuthStatus.signedIn, uid: uid, roles: roles);

  final AuthStatus status;
  final String? uid;
  final List<String> roles;

  bool get isLoading => status == AuthStatus.loading;
  bool get isSignedIn => status == AuthStatus.signedIn;
  bool get isAdmin => roles.contains('admin');
}

@riverpod
Stream<AuthState> _rawAuthState(Ref ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  return fb_auth.FirebaseAuth.instance.authStateChanges().asyncExpand((user) {
    if (user == null) return Stream.value(const AuthState.signedOut());
    return userRepo
        .watchUser(user.uid)
        .map(
          (model) => AuthState.signedIn(
            uid: user.uid,
            roles: model?.roles ?? const [],
          ),
        );
  });
}

@Riverpod(keepAlive: true)
AuthState authState(Ref ref) {
  return ref.watch(_rawAuthStateProvider).value ?? const AuthState.loading();
}
