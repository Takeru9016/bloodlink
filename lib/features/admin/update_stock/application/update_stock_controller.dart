import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/partner_model.dart';
import '../../../../data/models/stock_entry_model.dart';
import '../../../../data/repositories/partner_repository.dart';

part 'update_stock_controller.g.dart';

@riverpod
Future<List<({String id, PartnerModel partner})>> stockPartnerList(Ref ref) {
  return ref.read(partnerRepositoryProvider).listPartners();
}

@riverpod
Future<Map<String, StockEntryModel>> partnerStock(Ref ref, String partnerId) {
  return ref.read(partnerRepositoryProvider).getStock(partnerId);
}

@riverpod
class UpdateStockController extends _$UpdateStockController {
  @override
  FutureOr<void> build() {}

  /// Writes only the changed cells and returns whether the save succeeded
  /// (the error, if any, is left on [state] for the screen to surface).
  Future<bool> save({
    required String partnerId,
    required Map<String, int> changedCells,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw StateError(
          'No signed-in admin — cannot attribute this stock update.',
        );
      }
      final adminUid = firebaseUser.uid;
      final repo = ref.read(partnerRepositoryProvider);
      for (final entry in changedCells.entries) {
        await repo.updateStock(partnerId, entry.key, entry.value, adminUid);
      }
    });
    return !state.hasError;
  }
}
