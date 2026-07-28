// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bankProfilePartner)
final bankProfilePartnerProvider = BankProfilePartnerFamily._();

final class BankProfilePartnerProvider
    extends
        $FunctionalProvider<
          AsyncValue<PartnerModel?>,
          PartnerModel?,
          FutureOr<PartnerModel?>
        >
    with $FutureModifier<PartnerModel?>, $FutureProvider<PartnerModel?> {
  BankProfilePartnerProvider._({
    required BankProfilePartnerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bankProfilePartnerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bankProfilePartnerHash();

  @override
  String toString() {
    return r'bankProfilePartnerProvider'
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
    return bankProfilePartner(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BankProfilePartnerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bankProfilePartnerHash() =>
    r'bead89a3633bb39ea89bfbc2b29bc906e5256c3f';

final class BankProfilePartnerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PartnerModel?>, String> {
  BankProfilePartnerFamily._()
    : super(
        retry: null,
        name: r'bankProfilePartnerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BankProfilePartnerProvider call(String partnerId) =>
      BankProfilePartnerProvider._(argument: partnerId, from: this);

  @override
  String toString() => r'bankProfilePartnerProvider';
}

@ProviderFor(bankProfileStock)
final bankProfileStockProvider = BankProfileStockFamily._();

final class BankProfileStockProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, StockEntryModel>>,
          Map<String, StockEntryModel>,
          Stream<Map<String, StockEntryModel>>
        >
    with
        $FutureModifier<Map<String, StockEntryModel>>,
        $StreamProvider<Map<String, StockEntryModel>> {
  BankProfileStockProvider._({
    required BankProfileStockFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bankProfileStockProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bankProfileStockHash();

  @override
  String toString() {
    return r'bankProfileStockProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, StockEntryModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, StockEntryModel>> create(Ref ref) {
    final argument = this.argument as String;
    return bankProfileStock(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BankProfileStockProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bankProfileStockHash() => r'1de75ea4b2f40492499c4266cba08fb8a340194d';

final class BankProfileStockFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Map<String, StockEntryModel>>,
          String
        > {
  BankProfileStockFamily._()
    : super(
        retry: null,
        name: r'bankProfileStockProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BankProfileStockProvider call(String partnerId) =>
      BankProfileStockProvider._(argument: partnerId, from: this);

  @override
  String toString() => r'bankProfileStockProvider';
}
