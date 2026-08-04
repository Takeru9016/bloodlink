// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_camps_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManageCampsController)
final manageCampsControllerProvider = ManageCampsControllerProvider._();

final class ManageCampsControllerProvider
    extends
        $AsyncNotifierProvider<ManageCampsController, List<DonationCampEntry>> {
  ManageCampsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manageCampsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manageCampsControllerHash();

  @$internal
  @override
  ManageCampsController create() => ManageCampsController();
}

String _$manageCampsControllerHash() =>
    r'36d6b2bbf5bdd02deac6d73c0ff174b4d8858465';

abstract class _$ManageCampsController
    extends $AsyncNotifier<List<DonationCampEntry>> {
  FutureOr<List<DonationCampEntry>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<DonationCampEntry>>,
              List<DonationCampEntry>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<DonationCampEntry>>,
                List<DonationCampEntry>
              >,
              AsyncValue<List<DonationCampEntry>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
