import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/partner_model.dart';
import '../../../data/models/stock_entry_model.dart';
import '../../../data/repositories/partner_repository.dart';

part 'bank_profile_controller.g.dart';

@riverpod
Future<PartnerModel?> bankProfilePartner(Ref ref, String partnerId) {
  return ref.read(partnerRepositoryProvider).getPartner(partnerId);
}

@riverpod
Stream<Map<String, StockEntryModel>> bankProfileStock(
  Ref ref,
  String partnerId,
) {
  return ref.read(partnerRepositoryProvider).watchStock(partnerId);
}

Timestamp? mostRecentStockUpdate(Map<String, StockEntryModel> stock) {
  if (stock.isEmpty) return null;
  return stock.values
      .map((entry) => entry.lastUpdatedAt)
      .reduce((a, b) => a.compareTo(b) >= 0 ? a : b);
}
