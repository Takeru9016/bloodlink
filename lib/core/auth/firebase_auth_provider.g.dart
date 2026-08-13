// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI seam for [FirebaseAuth.instance] — overridden in tests with
/// `firebase_auth_mocks`' `MockFirebaseAuth` so `AuthController`'s
/// sign-up/sign-in flows are unit-testable without a real Firebase project.

@ProviderFor(firebaseAuth)
final firebaseAuthProvider = FirebaseAuthProvider._();

/// DI seam for [FirebaseAuth.instance] — overridden in tests with
/// `firebase_auth_mocks`' `MockFirebaseAuth` so `AuthController`'s
/// sign-up/sign-in flows are unit-testable without a real Firebase project.

final class FirebaseAuthProvider
    extends $FunctionalProvider<FirebaseAuth, FirebaseAuth, FirebaseAuth>
    with $Provider<FirebaseAuth> {
  /// DI seam for [FirebaseAuth.instance] — overridden in tests with
  /// `firebase_auth_mocks`' `MockFirebaseAuth` so `AuthController`'s
  /// sign-up/sign-in flows are unit-testable without a real Firebase project.
  FirebaseAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthHash();

  @$internal
  @override
  $ProviderElement<FirebaseAuth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseAuth create(Ref ref) {
    return firebaseAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAuth>(value),
    );
  }
}

String _$firebaseAuthHash() => r'8c3e9d11b27110ca96130356b5ef4d5d34a5ffc2';
