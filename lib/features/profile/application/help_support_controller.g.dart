// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_support_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HelpSupportController)
final helpSupportControllerProvider = HelpSupportControllerProvider._();

final class HelpSupportControllerProvider
    extends $AsyncNotifierProvider<HelpSupportController, HelpSupportState> {
  HelpSupportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'helpSupportControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$helpSupportControllerHash();

  @$internal
  @override
  HelpSupportController create() => HelpSupportController();
}

String _$helpSupportControllerHash() =>
    r'b85363ecdddc5b022d0e46e6ce24661b701e84e3';

abstract class _$HelpSupportController
    extends $AsyncNotifier<HelpSupportState> {
  FutureOr<HelpSupportState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<HelpSupportState>, HelpSupportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HelpSupportState>, HelpSupportState>,
              AsyncValue<HelpSupportState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
