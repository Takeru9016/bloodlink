// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_profile_setup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DonorProfileSetupController)
final donorProfileSetupControllerProvider =
    DonorProfileSetupControllerProvider._();

final class DonorProfileSetupControllerProvider
    extends $AsyncNotifierProvider<DonorProfileSetupController, void> {
  DonorProfileSetupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'donorProfileSetupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$donorProfileSetupControllerHash();

  @$internal
  @override
  DonorProfileSetupController create() => DonorProfileSetupController();
}

String _$donorProfileSetupControllerHash() =>
    r'091b9adbb41fa355bf4bf466353739af039f586d';

abstract class _$DonorProfileSetupController extends $AsyncNotifier<void> {
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
