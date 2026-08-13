import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_provider.g.dart';

/// DI seam for [FirebaseAuth.instance] — overridden in tests with
/// `firebase_auth_mocks`' `MockFirebaseAuth` so `AuthController`'s
/// sign-up/sign-in flows are unit-testable without a real Firebase project.
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;
