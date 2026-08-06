// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_banner_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(partnersForBannerLink)
final partnersForBannerLinkProvider = PartnersForBannerLinkProvider._();

final class PartnersForBannerLinkProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<({String id, PartnerModel partner})>>,
          List<({String id, PartnerModel partner})>,
          FutureOr<List<({String id, PartnerModel partner})>>
        >
    with
        $FutureModifier<List<({String id, PartnerModel partner})>>,
        $FutureProvider<List<({String id, PartnerModel partner})>> {
  PartnersForBannerLinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnersForBannerLinkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnersForBannerLinkHash();

  @$internal
  @override
  $FutureProviderElement<List<({String id, PartnerModel partner})>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<({String id, PartnerModel partner})>> create(Ref ref) {
    return partnersForBannerLink(ref);
  }
}

String _$partnersForBannerLinkHash() =>
    r'2993905a33941fe296e12d03764470d9e65586f4';

@ProviderFor(UploadBannerController)
final uploadBannerControllerProvider = UploadBannerControllerProvider._();

final class UploadBannerControllerProvider
    extends $AsyncNotifierProvider<UploadBannerController, void> {
  UploadBannerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadBannerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadBannerControllerHash();

  @$internal
  @override
  UploadBannerController create() => UploadBannerController();
}

String _$uploadBannerControllerHash() =>
    r'122731e0442b843fb63916b2daf189ab084da304';

abstract class _$UploadBannerController extends $AsyncNotifier<void> {
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
