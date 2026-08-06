// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_contact_admin_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SupportContactAdminController)
final supportContactAdminControllerProvider =
    SupportContactAdminControllerProvider._();

final class SupportContactAdminControllerProvider
    extends
        $AsyncNotifierProvider<
          SupportContactAdminController,
          SupportContactModel?
        > {
  SupportContactAdminControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportContactAdminControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportContactAdminControllerHash();

  @$internal
  @override
  SupportContactAdminController create() => SupportContactAdminController();
}

String _$supportContactAdminControllerHash() =>
    r'fad7538dcae6a4195baef79245948489fd0b3abe';

abstract class _$SupportContactAdminController
    extends $AsyncNotifier<SupportContactModel?> {
  FutureOr<SupportContactModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<SupportContactModel?>, SupportContactModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SupportContactModel?>,
                SupportContactModel?
              >,
              AsyncValue<SupportContactModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
