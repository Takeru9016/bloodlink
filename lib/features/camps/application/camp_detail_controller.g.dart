// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camp_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(campDetail)
final campDetailProvider = CampDetailFamily._();

final class CampDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<DonationCampModel?>,
          DonationCampModel?,
          FutureOr<DonationCampModel?>
        >
    with
        $FutureModifier<DonationCampModel?>,
        $FutureProvider<DonationCampModel?> {
  CampDetailProvider._({
    required CampDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'campDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$campDetailHash();

  @override
  String toString() {
    return r'campDetailProvider'
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
    return campDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CampDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$campDetailHash() => r'de6f97711f7f56928609cb13b6aa38ff03a34431';

final class CampDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DonationCampModel?>, String> {
  CampDetailFamily._()
    : super(
        retry: null,
        name: r'campDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CampDetailProvider call(String campId) =>
      CampDetailProvider._(argument: campId, from: this);

  @override
  String toString() => r'campDetailProvider';
}

@ProviderFor(campRsvpCount)
final campRsvpCountProvider = CampRsvpCountFamily._();

final class CampRsvpCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  CampRsvpCountProvider._({
    required CampRsvpCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'campRsvpCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$campRsvpCountHash();

  @override
  String toString() {
    return r'campRsvpCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return campRsvpCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CampRsvpCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$campRsvpCountHash() => r'91dc072a04fb1218fb2655f82ef8de680fda4ce1';

final class CampRsvpCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  CampRsvpCountFamily._()
    : super(
        retry: null,
        name: r'campRsvpCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CampRsvpCountProvider call(String campId) =>
      CampRsvpCountProvider._(argument: campId, from: this);

  @override
  String toString() => r'campRsvpCountProvider';
}

@ProviderFor(campRsvpStatus)
final campRsvpStatusProvider = CampRsvpStatusFamily._();

final class CampRsvpStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  CampRsvpStatusProvider._({
    required CampRsvpStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'campRsvpStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$campRsvpStatusHash();

  @override
  String toString() {
    return r'campRsvpStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as String;
    return campRsvpStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CampRsvpStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$campRsvpStatusHash() => r'f1471d71e4644602852c43e4bcc67628553d2da9';

final class CampRsvpStatusFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, String> {
  CampRsvpStatusFamily._()
    : super(
        retry: null,
        name: r'campRsvpStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CampRsvpStatusProvider call(String campId) =>
      CampRsvpStatusProvider._(argument: campId, from: this);

  @override
  String toString() => r'campRsvpStatusProvider';
}

@ProviderFor(CampRsvpController)
final campRsvpControllerProvider = CampRsvpControllerProvider._();

final class CampRsvpControllerProvider
    extends $AsyncNotifierProvider<CampRsvpController, void> {
  CampRsvpControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'campRsvpControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$campRsvpControllerHash();

  @$internal
  @override
  CampRsvpController create() => CampRsvpController();
}

String _$campRsvpControllerHash() =>
    r'db4cfd8ddca0808cfe2860d392574db2c38b9c37';

abstract class _$CampRsvpController extends $AsyncNotifier<void> {
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
