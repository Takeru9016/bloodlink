import 'package:bloodlink/data/models/stock_entry_model.dart';
import 'package:bloodlink/features/bank_locator/application/bank_profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

StockEntryModel _entry({required int unitCount, Timestamp? lastUpdatedAt}) {
  return StockEntryModel(
    unitCount: unitCount,
    lastUpdatedBy: 'admin-1',
    lastUpdatedAt: lastUpdatedAt,
  );
}

void main() {
  group('mostRecentStockUpdate', () {
    test('empty stock returns null', () {
      expect(mostRecentStockUpdate({}), isNull);
    });

    test('all-null timestamps (pending server timestamp) returns null', () {
      final stock = {'A+': _entry(unitCount: 1), 'O-': _entry(unitCount: 2)};
      expect(mostRecentStockUpdate(stock), isNull);
    });

    test('mixed null and resolved timestamps returns the max resolved one', () {
      final older = Timestamp.fromDate(DateTime(2026, 1, 1));
      final newer = Timestamp.fromDate(DateTime(2026, 6, 1));
      final stock = {
        'A+': _entry(unitCount: 1, lastUpdatedAt: older),
        'O-': _entry(unitCount: 2),
        'B+': _entry(unitCount: 3, lastUpdatedAt: newer),
      };
      expect(mostRecentStockUpdate(stock), newer);
    });
  });
}
