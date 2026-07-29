// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matched_banks_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(matchedBanksRequest)
final matchedBanksRequestProvider = MatchedBanksRequestFamily._();

final class MatchedBanksRequestProvider
    extends
        $FunctionalProvider<
          AsyncValue<BloodRequestModel?>,
          BloodRequestModel?,
          Stream<BloodRequestModel?>
        >
    with
        $FutureModifier<BloodRequestModel?>,
        $StreamProvider<BloodRequestModel?> {
  MatchedBanksRequestProvider._({
    required MatchedBanksRequestFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'matchedBanksRequestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$matchedBanksRequestHash();

  @override
  String toString() {
    return r'matchedBanksRequestProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<BloodRequestModel?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<BloodRequestModel?> create(Ref ref) {
    final argument = this.argument as String;
    return matchedBanksRequest(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MatchedBanksRequestProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$matchedBanksRequestHash() =>
    r'2ab75492544d5d742a9ac507d169ede6941f41da';

final class MatchedBanksRequestFamily extends $Family
    with $FunctionalFamilyOverride<Stream<BloodRequestModel?>, String> {
  MatchedBanksRequestFamily._()
    : super(
        retry: null,
        name: r'matchedBanksRequestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MatchedBanksRequestProvider call(String requestId) =>
      MatchedBanksRequestProvider._(argument: requestId, from: this);

  @override
  String toString() => r'matchedBanksRequestProvider';
}

@ProviderFor(matchedBankEntries)
final matchedBankEntriesProvider = MatchedBankEntriesFamily._();

final class MatchedBankEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MatchedBankEntry>>,
          List<MatchedBankEntry>,
          FutureOr<List<MatchedBankEntry>>
        >
    with
        $FutureModifier<List<MatchedBankEntry>>,
        $FutureProvider<List<MatchedBankEntry>> {
  MatchedBankEntriesProvider._({
    required MatchedBankEntriesFamily super.from,
    required MatchedBankEntriesArgs super.argument,
  }) : super(
         retry: null,
         name: r'matchedBankEntriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$matchedBankEntriesHash();

  @override
  String toString() {
    return r'matchedBankEntriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MatchedBankEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MatchedBankEntry>> create(Ref ref) {
    final argument = this.argument as MatchedBankEntriesArgs;
    return matchedBankEntries(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MatchedBankEntriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$matchedBankEntriesHash() =>
    r'b6ff12ccd09b3f69f7753618c2ffd28310a799b3';

final class MatchedBankEntriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<MatchedBankEntry>>,
          MatchedBankEntriesArgs
        > {
  MatchedBankEntriesFamily._()
    : super(
        retry: null,
        name: r'matchedBankEntriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MatchedBankEntriesProvider call(MatchedBankEntriesArgs args) =>
      MatchedBankEntriesProvider._(argument: args, from: this);

  @override
  String toString() => r'matchedBankEntriesProvider';
}
