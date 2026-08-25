// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_camp_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(donationCampRepository)
final donationCampRepositoryProvider = DonationCampRepositoryProvider._();

final class DonationCampRepositoryProvider
    extends
        $FunctionalProvider<
          DonationCampRepository,
          DonationCampRepository,
          DonationCampRepository
        >
    with $Provider<DonationCampRepository> {
  DonationCampRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'donationCampRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$donationCampRepositoryHash();

  @$internal
  @override
  $ProviderElement<DonationCampRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DonationCampRepository create(Ref ref) {
    return donationCampRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DonationCampRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DonationCampRepository>(value),
    );
  }
}

String _$donationCampRepositoryHash() =>
    r'298d69cfade0ccef5c9c98f8990c5bf1a8b2d2fe';
