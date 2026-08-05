import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/partner_model.dart';
import 'package:bloodlink/data/models/report_model.dart';
import 'package:bloodlink/data/models/stock_entry_model.dart';
import 'package:bloodlink/features/bank_locator/application/bank_profile_controller.dart';
import 'package:bloodlink/features/bank_locator/presentation/bank_profile_screen.dart';
import 'package:bloodlink/shared/widgets/report_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _bankId = 'bank-1';

PartnerModel _partner() {
  return PartnerModel(
    name: 'Test Blood Bank',
    address: '123 Main St',
    location: const GeoPoint(0, 0),
    phone: '555-0100',
    verificationStatus: VerificationStatus.verified,
    updatedBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        bankProfilePartnerProvider(
          _bankId,
        ).overrideWith((ref) async => _partner()),
        bankProfileStockProvider(
          _bankId,
        ).overrideWith((ref) => Stream.value(<String, StockEntryModel>{})),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const BankProfileScreen(bankId: _bankId),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders partner details and a report button for this bank', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Test Blood Bank'), findsOneWidget);
    expect(find.text('123 Main St'), findsOneWidget);
    expect(find.text('555-0100'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);

    final reportButton = tester.widget<ReportButton>(find.byType(ReportButton));
    expect(reportButton.targetType, ReportTargetType.partner);
    expect(reportButton.targetId, _bankId);
  });
}
