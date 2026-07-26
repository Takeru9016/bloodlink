import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_stub.g.dart';

/// Minimal shape the router needs to make redirect decisions.
///
/// Replaced by real Firebase Auth wiring in 1B-5 — only this file changes;
/// `app_router.dart` keeps reading `authStateProvider` the same way.
class AuthState {
  const AuthState({this.uid, this.roles = const []});

  final String? uid;
  final List<String> roles;

  bool get isSignedIn => uid != null;
  bool get isAdmin => roles.contains('admin');
}

@Riverpod(keepAlive: true)
AuthState authState(Ref ref) {
  return const AuthState();
}
