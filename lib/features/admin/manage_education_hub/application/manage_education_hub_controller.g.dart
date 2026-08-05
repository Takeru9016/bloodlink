// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_education_hub_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManageEducationHubController)
final manageEducationHubControllerProvider =
    ManageEducationHubControllerProvider._();

final class ManageEducationHubControllerProvider
    extends
        $AsyncNotifierProvider<
          ManageEducationHubController,
          List<({String id, EducationArticleModel model})>
        > {
  ManageEducationHubControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manageEducationHubControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manageEducationHubControllerHash();

  @$internal
  @override
  ManageEducationHubController create() => ManageEducationHubController();
}

String _$manageEducationHubControllerHash() =>
    r'e72fe09b2be77bf2fdcbdc817c1d0aeb99834a40';

abstract class _$ManageEducationHubController
    extends $AsyncNotifier<List<({String id, EducationArticleModel model})>> {
  FutureOr<List<({String id, EducationArticleModel model})>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<({String id, EducationArticleModel model})>>,
              List<({String id, EducationArticleModel model})>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<({String id, EducationArticleModel model})>>,
                List<({String id, EducationArticleModel model})>
              >,
              AsyncValue<List<({String id, EducationArticleModel model})>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
