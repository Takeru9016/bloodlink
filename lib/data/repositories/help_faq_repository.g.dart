// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_faq_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(helpFaqRepository)
final helpFaqRepositoryProvider = HelpFaqRepositoryProvider._();

final class HelpFaqRepositoryProvider
    extends
        $FunctionalProvider<
          HelpFaqRepository,
          HelpFaqRepository,
          HelpFaqRepository
        >
    with $Provider<HelpFaqRepository> {
  HelpFaqRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'helpFaqRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$helpFaqRepositoryHash();

  @$internal
  @override
  $ProviderElement<HelpFaqRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HelpFaqRepository create(Ref ref) {
    return helpFaqRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HelpFaqRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HelpFaqRepository>(value),
    );
  }
}

String _$helpFaqRepositoryHash() => r'14e3c70f57b095b466d2788e56c819a316145c1f';
