// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_item_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bannerItemRepository)
final bannerItemRepositoryProvider = BannerItemRepositoryProvider._();

final class BannerItemRepositoryProvider
    extends
        $FunctionalProvider<
          BannerItemRepository,
          BannerItemRepository,
          BannerItemRepository
        >
    with $Provider<BannerItemRepository> {
  BannerItemRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bannerItemRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bannerItemRepositoryHash();

  @$internal
  @override
  $ProviderElement<BannerItemRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BannerItemRepository create(Ref ref) {
    return bannerItemRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BannerItemRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BannerItemRepository>(value),
    );
  }
}

String _$bannerItemRepositoryHash() =>
    r'4fc3d8502f5498e58e29532f15829566c75364b5';
