// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_verification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myDonorProfile)
final myDonorProfileProvider = MyDonorProfileProvider._();

final class MyDonorProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<DonorProfileModel?>,
          DonorProfileModel?,
          Stream<DonorProfileModel?>
        >
    with
        $FutureModifier<DonorProfileModel?>,
        $StreamProvider<DonorProfileModel?> {
  MyDonorProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myDonorProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myDonorProfileHash();

  @$internal
  @override
  $StreamProviderElement<DonorProfileModel?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DonorProfileModel?> create(Ref ref) {
    return myDonorProfile(ref);
  }
}

String _$myDonorProfileHash() => r'21e2b428d71e14d539ffbe18e3155524ed3f6010';

@ProviderFor(DonorVerificationController)
final donorVerificationControllerProvider =
    DonorVerificationControllerProvider._();

final class DonorVerificationControllerProvider
    extends $AsyncNotifierProvider<DonorVerificationController, void> {
  DonorVerificationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'donorVerificationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$donorVerificationControllerHash();

  @$internal
  @override
  DonorVerificationController create() => DonorVerificationController();
}

String _$donorVerificationControllerHash() =>
    r'000aaa501d1de2f8ad4cd44fe527eabe13e128ec';

abstract class _$DonorVerificationController extends $AsyncNotifier<void> {
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
