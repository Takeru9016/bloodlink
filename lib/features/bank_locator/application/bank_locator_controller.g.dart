// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_locator_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BankLocatorController)
final bankLocatorControllerProvider = BankLocatorControllerProvider._();

final class BankLocatorControllerProvider
    extends $AsyncNotifierProvider<BankLocatorController, BankLocatorState> {
  BankLocatorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bankLocatorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bankLocatorControllerHash();

  @$internal
  @override
  BankLocatorController create() => BankLocatorController();
}

String _$bankLocatorControllerHash() =>
    r'1124d67f6a5ce6b4ce21c97021b84888e0d1c895';

abstract class _$BankLocatorController
    extends $AsyncNotifier<BankLocatorState> {
  FutureOr<BankLocatorState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<BankLocatorState>, BankLocatorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BankLocatorState>, BankLocatorState>,
              AsyncValue<BankLocatorState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
