import 'dart:io';

import 'package:bloodlink/data/models/donation_camp_model.dart';
import 'package:bloodlink/data/repositories/donation_camp_repository.dart';
import 'package:bloodlink/features/camps/application/camp_listing_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

DonationCampModel _camp(String name) => DonationCampModel(
  name: name,
  description: 'Community drive',
  address: '123 Test Street',
  location: const GeoPoint(0, 0),
  date: Timestamp.fromDate(DateTime(2026, 9, 1)),
  hostName: 'City Hospital',
  createdBy: 'admin-1',
  updatedBy: 'admin-1',
);

class _FakeDonationCampRepository implements DonationCampRepository {
  _FakeDonationCampRepository(this.upcoming);

  final List<DonationCampEntry> upcoming;

  @override
  Future<List<DonationCampEntry>> listUpcomingCamps({DateTime? now}) async =>
      upcoming;

  @override
  Future<List<DonationCampEntry>> listAllCamps() async => upcoming;

  @override
  Future<DonationCampModel?> getCamp(String id) async => null;

  @override
  Future<String> createCamp(DonationCampModel camp, String adminUid) async => '';

  @override
  Future<String> uploadCampImage(File image) async => '';

  @override
  Future<void> updateCamp(
    String id,
    DonationCampModel camp,
    String adminUid,
  ) async {}

  @override
  Future<void> rsvp(String campId, String uid) async {}

  @override
  Future<void> cancelRsvp(String campId, String uid) async {}

  @override
  Stream<bool> watchRsvpStatus(String campId, String uid) =>
      const Stream.empty();

  @override
  Stream<int> watchRsvpCount(String campId) => const Stream.empty();

  @override
  Future<int> rsvpCount(String campId) async => 0;
}

void main() {
  group('CampListingController.build', () {
    test('lists upcoming camps in repository order, distances unresolved yet', () async {
      // Distance resolution runs unawaited via geolocator, which has no
      // platform channel in a plain unit test and never actually resolves
      // here — this asserts build()'s synchronous initial state, not the
      // post-location state (see bank_locator_controller_test.dart for the
      // same reasoning).
      final fakeRepo = _FakeDonationCampRepository([
        (id: 'c1', camp: _camp('Downtown Drive')),
        (id: 'c2', camp: _camp('Riverside Drive')),
      ]);
      final container = ProviderContainer(
        overrides: [donationCampRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      final state = await container.read(campListingControllerProvider.future);

      expect(state.locationStatus, CampLocationStatus.resolving);
      expect(
        state.entries.map((e) => e.camp.name),
        ['Downtown Drive', 'Riverside Drive'],
      );
      expect(state.entries.every((e) => e.distanceMeters == null), isTrue);
    });
  });

  group('CampListingController.refresh', () {
    test('re-fetches the camp list', () async {
      final fakeRepo = _FakeDonationCampRepository([
        (id: 'c1', camp: _camp('Downtown Drive')),
      ]);
      final container = ProviderContainer(
        overrides: [donationCampRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      await container.read(campListingControllerProvider.future);
      await container.read(campListingControllerProvider.notifier).refresh();

      final state = container.read(campListingControllerProvider).value!;
      expect(state.entries, hasLength(1));
    });
  });
}
