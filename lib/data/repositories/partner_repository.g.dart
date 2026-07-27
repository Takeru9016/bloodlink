// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(partnerRepository)
final partnerRepositoryProvider = PartnerRepositoryProvider._();

final class PartnerRepositoryProvider
    extends
        $FunctionalProvider<
          PartnerRepository,
          PartnerRepository,
          PartnerRepository
        >
    with $Provider<PartnerRepository> {
  PartnerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerRepositoryHash();

  @$internal
  @override
  $ProviderElement<PartnerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PartnerRepository create(Ref ref) {
    return partnerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartnerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartnerRepository>(value),
    );
  }
}

String _$partnerRepositoryHash() => r'428bb61f6caa876be5a49598b631d1fdf704e0f2';
