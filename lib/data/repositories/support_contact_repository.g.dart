// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_contact_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supportContactRepository)
final supportContactRepositoryProvider = SupportContactRepositoryProvider._();

final class SupportContactRepositoryProvider
    extends
        $FunctionalProvider<
          SupportContactRepository,
          SupportContactRepository,
          SupportContactRepository
        >
    with $Provider<SupportContactRepository> {
  SupportContactRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportContactRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportContactRepositoryHash();

  @$internal
  @override
  $ProviderElement<SupportContactRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupportContactRepository create(Ref ref) {
    return supportContactRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupportContactRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupportContactRepository>(value),
    );
  }
}

String _$supportContactRepositoryHash() =>
    r'ca83e31ee8e6a522369fb94bf913f9f255de1030';
