// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(partnerById)
final partnerByIdProvider = PartnerByIdFamily._();

final class PartnerByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<PartnerModel?>,
          PartnerModel?,
          FutureOr<PartnerModel?>
        >
    with $FutureModifier<PartnerModel?>, $FutureProvider<PartnerModel?> {
  PartnerByIdProvider._({
    required PartnerByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'partnerByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$partnerByIdHash();

  @override
  String toString() {
    return r'partnerByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PartnerModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PartnerModel?> create(Ref ref) {
    final argument = this.argument as String;
    return partnerById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PartnerByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$partnerByIdHash() => r'5763373ef866b121f7d9efe6b75177360df533db';

final class PartnerByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PartnerModel?>, String> {
  PartnerByIdFamily._()
    : super(
        retry: null,
        name: r'partnerByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PartnerByIdProvider call(String partnerId) =>
      PartnerByIdProvider._(argument: partnerId, from: this);

  @override
  String toString() => r'partnerByIdProvider';
}

@ProviderFor(PartnerFormController)
final partnerFormControllerProvider = PartnerFormControllerProvider._();

final class PartnerFormControllerProvider
    extends $AsyncNotifierProvider<PartnerFormController, void> {
  PartnerFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerFormControllerHash();

  @$internal
  @override
  PartnerFormController create() => PartnerFormController();
}

String _$partnerFormControllerHash() =>
    r'1c594e5a4f681045eb69071b6dbe1439ef2fe176';

abstract class _$PartnerFormController extends $AsyncNotifier<void> {
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
