// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camp_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(campById)
final campByIdProvider = CampByIdFamily._();

final class CampByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<DonationCampModel?>,
          DonationCampModel?,
          FutureOr<DonationCampModel?>
        >
    with
        $FutureModifier<DonationCampModel?>,
        $FutureProvider<DonationCampModel?> {
  CampByIdProvider._({
    required CampByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'campByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$campByIdHash();

  @override
  String toString() {
    return r'campByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DonationCampModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DonationCampModel?> create(Ref ref) {
    final argument = this.argument as String;
    return campById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CampByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$campByIdHash() => r'1304362939689878c10323c2da340a068b229b08';

final class CampByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DonationCampModel?>, String> {
  CampByIdFamily._()
    : super(
        retry: null,
        name: r'campByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CampByIdProvider call(String campId) =>
      CampByIdProvider._(argument: campId, from: this);

  @override
  String toString() => r'campByIdProvider';
}

@ProviderFor(CampFormController)
final campFormControllerProvider = CampFormControllerProvider._();

final class CampFormControllerProvider
    extends $AsyncNotifierProvider<CampFormController, void> {
  CampFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'campFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$campFormControllerHash();

  @$internal
  @override
  CampFormController create() => CampFormController();
}

String _$campFormControllerHash() =>
    r'605318914171c7d1cb327769ed96b35a6e9cb370';

abstract class _$CampFormController extends $AsyncNotifier<void> {
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
