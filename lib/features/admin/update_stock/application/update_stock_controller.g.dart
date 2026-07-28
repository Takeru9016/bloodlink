// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_stock_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stockPartnerList)
final stockPartnerListProvider = StockPartnerListProvider._();

final class StockPartnerListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<({String id, PartnerModel partner})>>,
          List<({String id, PartnerModel partner})>,
          FutureOr<List<({String id, PartnerModel partner})>>
        >
    with
        $FutureModifier<List<({String id, PartnerModel partner})>>,
        $FutureProvider<List<({String id, PartnerModel partner})>> {
  StockPartnerListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockPartnerListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockPartnerListHash();

  @$internal
  @override
  $FutureProviderElement<List<({String id, PartnerModel partner})>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<({String id, PartnerModel partner})>> create(Ref ref) {
    return stockPartnerList(ref);
  }
}

String _$stockPartnerListHash() => r'9e6d1c6f8e17133b32b6453253f94ba039ce5f05';

@ProviderFor(partnerStock)
final partnerStockProvider = PartnerStockFamily._();

final class PartnerStockProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, StockEntryModel>>,
          Map<String, StockEntryModel>,
          FutureOr<Map<String, StockEntryModel>>
        >
    with
        $FutureModifier<Map<String, StockEntryModel>>,
        $FutureProvider<Map<String, StockEntryModel>> {
  PartnerStockProvider._({
    required PartnerStockFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'partnerStockProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$partnerStockHash();

  @override
  String toString() {
    return r'partnerStockProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, StockEntryModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, StockEntryModel>> create(Ref ref) {
    final argument = this.argument as String;
    return partnerStock(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PartnerStockProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$partnerStockHash() => r'25a2ecd9b126c1b00abcd3b7fd077992cf0b4846';

final class PartnerStockFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, StockEntryModel>>,
          String
        > {
  PartnerStockFamily._()
    : super(
        retry: null,
        name: r'partnerStockProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PartnerStockProvider call(String partnerId) =>
      PartnerStockProvider._(argument: partnerId, from: this);

  @override
  String toString() => r'partnerStockProvider';
}

@ProviderFor(UpdateStockController)
final updateStockControllerProvider = UpdateStockControllerProvider._();

final class UpdateStockControllerProvider
    extends $AsyncNotifierProvider<UpdateStockController, void> {
  UpdateStockControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateStockControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateStockControllerHash();

  @$internal
  @override
  UpdateStockController create() => UpdateStockController();
}

String _$updateStockControllerHash() =>
    r'8d4d7885cb3ba8229ca8a83398f972f7a4500825';

abstract class _$UpdateStockController extends $AsyncNotifier<void> {
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
