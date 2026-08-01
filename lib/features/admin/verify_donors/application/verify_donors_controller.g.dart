// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_donors_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Live — reflects a donor's resubmission (or a fresh pending entry)
/// immediately, so the queue never shows a cached/first-submitted photo.

@ProviderFor(pendingDonors)
final pendingDonorsProvider = PendingDonorsProvider._();

/// Live — reflects a donor's resubmission (or a fresh pending entry)
/// immediately, so the queue never shows a cached/first-submitted photo.

final class PendingDonorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<({String id, DonorProfileModel profile})>>,
          List<({String id, DonorProfileModel profile})>,
          Stream<List<({String id, DonorProfileModel profile})>>
        >
    with
        $FutureModifier<List<({String id, DonorProfileModel profile})>>,
        $StreamProvider<List<({String id, DonorProfileModel profile})>> {
  /// Live — reflects a donor's resubmission (or a fresh pending entry)
  /// immediately, so the queue never shows a cached/first-submitted photo.
  PendingDonorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingDonorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingDonorsHash();

  @$internal
  @override
  $StreamProviderElement<List<({String id, DonorProfileModel profile})>>
  $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<({String id, DonorProfileModel profile})>> create(Ref ref) {
    return pendingDonors(ref);
  }
}

String _$pendingDonorsHash() => r'8beddf630f18f8ef69af0c04a68f0bc7a9d946e1';

@ProviderFor(donorUser)
final donorUserProvider = DonorUserFamily._();

final class DonorUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel?>,
          UserModel?,
          FutureOr<UserModel?>
        >
    with $FutureModifier<UserModel?>, $FutureProvider<UserModel?> {
  DonorUserProvider._({
    required DonorUserFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'donorUserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$donorUserHash();

  @override
  String toString() {
    return r'donorUserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserModel?> create(Ref ref) {
    final argument = this.argument as String;
    return donorUser(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DonorUserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$donorUserHash() => r'efd361fde22adaa6f2bca8858a76b493a1bbf223';

final class DonorUserFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserModel?>, String> {
  DonorUserFamily._()
    : super(
        retry: null,
        name: r'donorUserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DonorUserProvider call(String uid) =>
      DonorUserProvider._(argument: uid, from: this);

  @override
  String toString() => r'donorUserProvider';
}

@ProviderFor(VerifyDonorsController)
final verifyDonorsControllerProvider = VerifyDonorsControllerProvider._();

final class VerifyDonorsControllerProvider
    extends $AsyncNotifierProvider<VerifyDonorsController, void> {
  VerifyDonorsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verifyDonorsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verifyDonorsControllerHash();

  @$internal
  @override
  VerifyDonorsController create() => VerifyDonorsController();
}

String _$verifyDonorsControllerHash() =>
    r'daf195a2ed023b118616806d8458821778526636';

abstract class _$VerifyDonorsController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
