// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_partners_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManagePartnersController)
final managePartnersControllerProvider = ManagePartnersControllerProvider._();

final class ManagePartnersControllerProvider
    extends
        $AsyncNotifierProvider<
          ManagePartnersController,
          List<({String id, PartnerModel partner})>
        > {
  ManagePartnersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managePartnersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managePartnersControllerHash();

  @$internal
  @override
  ManagePartnersController create() => ManagePartnersController();
}

String _$managePartnersControllerHash() =>
    r'2b5e4772c2a7ede3c73fc22afb7f6c94171137ea';

abstract class _$ManagePartnersController
    extends $AsyncNotifier<List<({String id, PartnerModel partner})>> {
  FutureOr<List<({String id, PartnerModel partner})>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<({String id, PartnerModel partner})>>,
              List<({String id, PartnerModel partner})>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<({String id, PartnerModel partner})>>,
                List<({String id, PartnerModel partner})>
              >,
              AsyncValue<List<({String id, PartnerModel partner})>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
