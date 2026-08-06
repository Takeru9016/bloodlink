// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(faqById)
final faqByIdProvider = FaqByIdFamily._();

final class FaqByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<HelpFaqModel?>,
          HelpFaqModel?,
          FutureOr<HelpFaqModel?>
        >
    with $FutureModifier<HelpFaqModel?>, $FutureProvider<HelpFaqModel?> {
  FaqByIdProvider._({
    required FaqByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'faqByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$faqByIdHash();

  @override
  String toString() {
    return r'faqByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HelpFaqModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HelpFaqModel?> create(Ref ref) {
    final argument = this.argument as String;
    return faqById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FaqByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$faqByIdHash() => r'0db5e3cb08da53275c3069fdd85d89728ef8fcad';

final class FaqByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HelpFaqModel?>, String> {
  FaqByIdFamily._()
    : super(
        retry: null,
        name: r'faqByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FaqByIdProvider call(String faqId) =>
      FaqByIdProvider._(argument: faqId, from: this);

  @override
  String toString() => r'faqByIdProvider';
}

@ProviderFor(FaqFormController)
final faqFormControllerProvider = FaqFormControllerProvider._();

final class FaqFormControllerProvider
    extends $AsyncNotifierProvider<FaqFormController, void> {
  FaqFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faqFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faqFormControllerHash();

  @$internal
  @override
  FaqFormController create() => FaqFormController();
}

String _$faqFormControllerHash() => r'195d3dba766d7bb76e47637589afc9ba8a2c2ded';

abstract class _$FaqFormController extends $AsyncNotifier<void> {
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
