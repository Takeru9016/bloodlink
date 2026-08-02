// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_directory_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DonorDirectoryController)
final donorDirectoryControllerProvider = DonorDirectoryControllerProvider._();

final class DonorDirectoryControllerProvider
    extends
        $AsyncNotifierProvider<DonorDirectoryController, DonorDirectoryState> {
  DonorDirectoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'donorDirectoryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$donorDirectoryControllerHash();

  @$internal
  @override
  DonorDirectoryController create() => DonorDirectoryController();
}

String _$donorDirectoryControllerHash() =>
    r'1ff8805d2e0d11c354d473fcf616137e07466765';

abstract class _$DonorDirectoryController
    extends $AsyncNotifier<DonorDirectoryState> {
  FutureOr<DonorDirectoryState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DonorDirectoryState>, DonorDirectoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DonorDirectoryState>, DonorDirectoryState>,
              AsyncValue<DonorDirectoryState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
