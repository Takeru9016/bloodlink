// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_request_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bloodRequestRepository)
final bloodRequestRepositoryProvider = BloodRequestRepositoryProvider._();

final class BloodRequestRepositoryProvider
    extends
        $FunctionalProvider<
          BloodRequestRepository,
          BloodRequestRepository,
          BloodRequestRepository
        >
    with $Provider<BloodRequestRepository> {
  BloodRequestRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bloodRequestRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bloodRequestRepositoryHash();

  @$internal
  @override
  $ProviderElement<BloodRequestRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BloodRequestRepository create(Ref ref) {
    return bloodRequestRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BloodRequestRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BloodRequestRepository>(value),
    );
  }
}

String _$bloodRequestRepositoryHash() =>
    r'94fe4192f0619a4087dfb8fa78d72815f8647266';
