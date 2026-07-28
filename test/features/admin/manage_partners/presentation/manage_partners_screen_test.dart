import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/partner_model.dart';
import 'package:bloodlink/features/admin/manage_partners/application/manage_partners_controller.dart';
import 'package:bloodlink/features/admin/manage_partners/presentation/manage_partners_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

PartnerModel _partner(String name, VerificationStatus status) {
  return PartnerModel(
    name: name,
    address: '123 Main St',
    location: const GeoPoint(0, 0),
    phone: '+10000000000',
    verificationStatus: status,
    updatedBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

class _FakeManagePartnersController extends ManagePartnersController {
  @override
  Future<List<({String id, PartnerModel partner})>> build() async {
    return [
      (
        id: 'p1',
        partner: _partner('Verified Bank', VerificationStatus.verified),
      ),
      (id: 'p2', partner: _partner('Pending Bank', VerificationStatus.pending)),
    ];
  }
}

class _EmptyManagePartnersController extends ManagePartnersController {
  @override
  Future<List<({String id, PartnerModel partner})>> build() async => [];
}

void main() {
  testWidgets('lists partners with verification badges', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          managePartnersControllerProvider.overrideWith(
            _FakeManagePartnersController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ManagePartnersScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Verified Bank'), findsOneWidget);
    expect(find.text('Pending Bank'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Add new partner'), findsOneWidget);
  });

  testWidgets('shows empty state when there are no partners', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          managePartnersControllerProvider.overrideWith(
            _EmptyManagePartnersController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ManagePartnersScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No partner banks yet'), findsOneWidget);
  });
}
