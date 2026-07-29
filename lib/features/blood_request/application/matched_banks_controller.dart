import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/blood_request_model.dart';
import '../../../data/models/partner_model.dart';
import '../../../data/repositories/blood_request_repository.dart';
import '../../../data/repositories/partner_repository.dart';

part 'matched_banks_controller.g.dart';

typedef MatchedBankEntry = ({
  String id,
  PartnerModel partner,
  int stockUnits,
  double distanceMeters,
});

typedef MatchedBankEntriesArgs = ({
  List<String> partnerIds,
  GeoPoint requestLocation,
  String bloodGroup,
});

@riverpod
Stream<BloodRequestModel?> matchedBanksRequest(Ref ref, String requestId) {
  return ref.watch(bloodRequestRepositoryProvider).watchRequest(requestId);
}

@riverpod
Future<List<MatchedBankEntry>> matchedBankEntries(
  Ref ref,
  MatchedBankEntriesArgs args,
) async {
  final repo = ref.read(partnerRepositoryProvider);

  final results = await Future.wait(
    args.partnerIds.map((id) async {
      final partner = await repo.getPartner(id);
      if (partner == null) return null;
      final stock = await repo.getStock(id);
      return (
        id: id,
        partner: partner,
        stockUnits: stock[args.bloodGroup]?.unitCount ?? 0,
        distanceMeters: Geolocator.distanceBetween(
          args.requestLocation.latitude,
          args.requestLocation.longitude,
          partner.location.latitude,
          partner.location.longitude,
        ),
      );
    }),
  );

  final entries = results.whereType<MatchedBankEntry>().toList()
    ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
  return entries;
}
