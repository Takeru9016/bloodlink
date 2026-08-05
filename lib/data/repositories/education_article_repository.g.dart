// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_article_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(educationArticleRepository)
final educationArticleRepositoryProvider =
    EducationArticleRepositoryProvider._();

final class EducationArticleRepositoryProvider
    extends
        $FunctionalProvider<
          EducationArticleRepository,
          EducationArticleRepository,
          EducationArticleRepository
        >
    with $Provider<EducationArticleRepository> {
  EducationArticleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'educationArticleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$educationArticleRepositoryHash();

  @$internal
  @override
  $ProviderElement<EducationArticleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EducationArticleRepository create(Ref ref) {
    return educationArticleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EducationArticleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EducationArticleRepository>(value),
    );
  }
}

String _$educationArticleRepositoryHash() =>
    r'2c6a96e40a9c6a14a61793525855f41f5a3e37f5';
