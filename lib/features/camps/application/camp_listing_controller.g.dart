// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camp_listing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CampListingController)
final campListingControllerProvider = CampListingControllerProvider._();

final class CampListingControllerProvider
    extends $AsyncNotifierProvider<CampListingController, CampListingState> {
  CampListingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'campListingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$campListingControllerHash();

  @$internal
  @override
  CampListingController create() => CampListingController();
}

String _$campListingControllerHash() =>
    r'52c841ab75de945e17472e4a0a62bb49ee329b7b';

abstract class _$CampListingController
    extends $AsyncNotifier<CampListingState> {
  FutureOr<CampListingState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CampListingState>, CampListingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CampListingState>, CampListingState>,
              AsyncValue<CampListingState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
