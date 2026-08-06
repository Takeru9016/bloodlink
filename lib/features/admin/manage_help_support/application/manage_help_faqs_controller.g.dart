// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_help_faqs_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManageHelpFaqsController)
final manageHelpFaqsControllerProvider = ManageHelpFaqsControllerProvider._();

final class ManageHelpFaqsControllerProvider
    extends
        $AsyncNotifierProvider<
          ManageHelpFaqsController,
          List<({String id, HelpFaqModel model})>
        > {
  ManageHelpFaqsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manageHelpFaqsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manageHelpFaqsControllerHash();

  @$internal
  @override
  ManageHelpFaqsController create() => ManageHelpFaqsController();
}

String _$manageHelpFaqsControllerHash() =>
    r'df0d11f1fc3f872e293ffd591e2850ca5a168c11';

abstract class _$ManageHelpFaqsController
    extends $AsyncNotifier<List<({String id, HelpFaqModel model})>> {
  FutureOr<List<({String id, HelpFaqModel model})>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<({String id, HelpFaqModel model})>>,
              List<({String id, HelpFaqModel model})>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<({String id, HelpFaqModel model})>>,
                List<({String id, HelpFaqModel model})>
              >,
              AsyncValue<List<({String id, HelpFaqModel model})>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
