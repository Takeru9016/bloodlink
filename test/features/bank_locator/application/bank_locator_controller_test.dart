import 'package:bloodlink/data/models/partner_model.dart';
import 'package:bloodlink/data/models/stock_entry_model.dart';
import 'package:bloodlink/data/repositories/partner_repository.dart';
import 'package:bloodlink/features/bank_locator/application/bank_locator_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

PartnerModel _partner(String name) => PartnerModel(
  name: name,
  address: '1 Main St',
  location: const GeoPoint(0, 0),
  phone: '+10000000000',
  verificationStatus: VerificationStatus.verified,
  updatedBy: 'admin-1',
  updatedAt: Timestamp.now(),
);

class _FakePartnerRepository implements PartnerRepository {
  _FakePartnerRepository(this.records);

  final List<({String id, PartnerModel partner})> records;
  bool? lastVerifiedOnly;

  @override
  Future<List<({String id, PartnerModel partner})>> listPartners({
    bool verifiedOnly = false,
  }) async {
    lastVerifiedOnly = verifiedOnly;
    return records;
  }

  @override
  Future<PartnerModel?> getPartner(String id) async => null;

  @override
  Future<String> createPartner(PartnerModel partner, String adminUid) async => '';

  @override
  Future<void> updatePartner(
    String id,
    PartnerModel partner,
    String adminUid,
  ) async {}

  @override
  Future<Map<String, StockEntryModel>> getStock(String partnerId) async => {};

  @override
  Future<void> updateStock(
    String partnerId,
    String bloodGroup,
    int unitCount,
    String adminUid,
  ) async {}

  @override
  Stream<Map<String, StockEntryModel>> watchStock(String partnerId) =>
      const Stream.empty();
}

void main() {
  group('BankLocatorController.build', () {
    test('lists verified-only partners sorted alphabetically by name', () async {
      final fakeRepo = _FakePartnerRepository([
        (id: 'p1', partner: _partner('Zion Blood Bank')),
        (id: 'p2', partner: _partner('Ashoka Blood Bank')),
      ]);
      final container = ProviderContainer(
        overrides: [partnerRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      final state = await container.read(bankLocatorControllerProvider.future);

      expect(fakeRepo.lastVerifiedOnly, isTrue);
      expect(
        state.entries.map((e) => e.partner.name),
        ['Ashoka Blood Bank', 'Zion Blood Bank'],
      );
    });

    test('starts as resolving with distances unset, before location settles', () async {
      // build() returns before its unawaited _resolveLocationAndReorder()
      // call completes — geolocator has no platform channel in a plain unit
      // test, so that call never actually resolves here (no
      // TestWidgetsFlutterBinding to service it). This asserts the
      // synchronous initial state build() produces, not the post-location
      // state, which would hang this test forever.
      final fakeRepo = _FakePartnerRepository([
        (id: 'p1', partner: _partner('Ashoka Blood Bank')),
      ]);
      final container = ProviderContainer(
        overrides: [partnerRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      final state = await container.read(bankLocatorControllerProvider.future);
      expect(state.locationStatus, BankLocationStatus.resolving);
      expect(state.entries.single.distanceMeters, isNull);
    });
  });

  group('BankLocatorController.refresh', () {
    test('re-fetches the partner list', () async {
      final fakeRepo = _FakePartnerRepository([
        (id: 'p1', partner: _partner('Ashoka Blood Bank')),
      ]);
      final container = ProviderContainer(
        overrides: [partnerRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      await container.read(bankLocatorControllerProvider.future);
      await container.read(bankLocatorControllerProvider.notifier).refresh();

      final state = container.read(bankLocatorControllerProvider).value!;
      expect(state.entries, hasLength(1));
    });
  });
}
