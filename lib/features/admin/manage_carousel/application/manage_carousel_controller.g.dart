// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_carousel_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManageCarouselController)
final manageCarouselControllerProvider = ManageCarouselControllerProvider._();

final class ManageCarouselControllerProvider
    extends
        $AsyncNotifierProvider<
          ManageCarouselController,
          List<({String id, BannerItemModel model})>
        > {
  ManageCarouselControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manageCarouselControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manageCarouselControllerHash();

  @$internal
  @override
  ManageCarouselController create() => ManageCarouselController();
}

String _$manageCarouselControllerHash() =>
    r'26e8f6107811944d691530e24abafda8ec2700ff';

abstract class _$ManageCarouselController
    extends $AsyncNotifier<List<({String id, BannerItemModel model})>> {
  FutureOr<List<({String id, BannerItemModel model})>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<({String id, BannerItemModel model})>>,
              List<({String id, BannerItemModel model})>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<({String id, BannerItemModel model})>>,
                List<({String id, BannerItemModel model})>
              >,
              AsyncValue<List<({String id, BannerItemModel model})>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
