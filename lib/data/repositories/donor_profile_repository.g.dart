// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_profile_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(donorProfileRepository)
final donorProfileRepositoryProvider = DonorProfileRepositoryProvider._();

final class DonorProfileRepositoryProvider
    extends
        $FunctionalProvider<
          DonorProfileRepository,
          DonorProfileRepository,
          DonorProfileRepository
        >
    with $Provider<DonorProfileRepository> {
  DonorProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'donorProfileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$donorProfileRepositoryHash();

  @$internal
  @override
  $ProviderElement<DonorProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DonorProfileRepository create(Ref ref) {
    return donorProfileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DonorProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DonorProfileRepository>(value),
    );
  }
}

String _$donorProfileRepositoryHash() =>
    r'e137cdc1b9a68f6a9031dc567096cad87a1e082e';
