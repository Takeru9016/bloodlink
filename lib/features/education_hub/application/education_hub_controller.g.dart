// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_hub_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EducationHubController)
final educationHubControllerProvider = EducationHubControllerProvider._();

final class EducationHubControllerProvider
    extends
        $AsyncNotifierProvider<
          EducationHubController,
          List<EducationArticleEntry>
        > {
  EducationHubControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'educationHubControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$educationHubControllerHash();

  @$internal
  @override
  EducationHubController create() => EducationHubController();
}

String _$educationHubControllerHash() =>
    r'6680e3ae291be2362bcff77623044b83065a2322';

abstract class _$EducationHubController
    extends $AsyncNotifier<List<EducationArticleEntry>> {
  FutureOr<List<EducationArticleEntry>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<EducationArticleEntry>>,
              List<EducationArticleEntry>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<EducationArticleEntry>>,
                List<EducationArticleEntry>
              >,
              AsyncValue<List<EducationArticleEntry>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(educationArticle)
final educationArticleProvider = EducationArticleFamily._();

final class EducationArticleProvider
    extends
        $FunctionalProvider<
          AsyncValue<EducationArticleModel?>,
          EducationArticleModel?,
          FutureOr<EducationArticleModel?>
        >
    with
        $FutureModifier<EducationArticleModel?>,
        $FutureProvider<EducationArticleModel?> {
  EducationArticleProvider._({
    required EducationArticleFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'educationArticleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$educationArticleHash();

  @override
  String toString() {
    return r'educationArticleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EducationArticleModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EducationArticleModel?> create(Ref ref) {
    final argument = this.argument as String;
    return educationArticle(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EducationArticleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$educationArticleHash() => r'5ae42d566409168ba8adf51d02cdd82f0bd7e961';

final class EducationArticleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EducationArticleModel?>, String> {
  EducationArticleFamily._()
    : super(
        retry: null,
        name: r'educationArticleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EducationArticleProvider call(String articleId) =>
      EducationArticleProvider._(argument: articleId, from: this);

  @override
  String toString() => r'educationArticleProvider';
}
