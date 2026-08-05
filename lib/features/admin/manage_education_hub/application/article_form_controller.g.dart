// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(articleById)
final articleByIdProvider = ArticleByIdFamily._();

final class ArticleByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<EducationArticleModel?>,
          EducationArticleModel?,
          FutureOr<EducationArticleModel?>
        >
    with
        $FutureModifier<EducationArticleModel?>,
        $FutureProvider<EducationArticleModel?> {
  ArticleByIdProvider._({
    required ArticleByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'articleByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$articleByIdHash();

  @override
  String toString() {
    return r'articleByIdProvider'
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
    return articleById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArticleByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$articleByIdHash() => r'0b73c7564fc5ea636c303435127f3cb4e8882bee';

final class ArticleByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EducationArticleModel?>, String> {
  ArticleByIdFamily._()
    : super(
        retry: null,
        name: r'articleByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ArticleByIdProvider call(String articleId) =>
      ArticleByIdProvider._(argument: articleId, from: this);

  @override
  String toString() => r'articleByIdProvider';
}

@ProviderFor(ArticleFormController)
final articleFormControllerProvider = ArticleFormControllerProvider._();

final class ArticleFormControllerProvider
    extends $AsyncNotifierProvider<ArticleFormController, void> {
  ArticleFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'articleFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$articleFormControllerHash();

  @$internal
  @override
  ArticleFormController create() => ArticleFormController();
}

String _$articleFormControllerHash() =>
    r'905aee92bb5531db706a398aad2211a9bc91560d';

abstract class _$ArticleFormController extends $AsyncNotifier<void> {
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
