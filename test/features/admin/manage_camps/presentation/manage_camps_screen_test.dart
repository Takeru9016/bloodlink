import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/repositories/donation_camp_repository.dart';
import 'package:bloodlink/data/models/donation_camp_model.dart';
import 'package:bloodlink/features/admin/manage_camps/application/manage_camps_controller.dart';
import 'package:bloodlink/features/admin/manage_camps/presentation/manage_camps_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

DonationCampModel _camp(String name, String hostName) {
  return DonationCampModel(
    name: name,
    description: 'Description',
    location: const GeoPoint(0, 0),
    date: Timestamp.fromDate(DateTime(2026, 12, 1)),
    hostName: hostName,
    createdBy: 'admin-uid',
    updatedBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

class _FakeManageCampsController extends ManageCampsController {
  @override
  Future<List<DonationCampEntry>> build() async {
    return [
      (id: 'c1', camp: _camp('City Blood Drive', 'City Blood Bank')),
      (id: 'c2', camp: _camp('Campus Drive', 'University Hospital')),
    ];
  }
}

class _EmptyManageCampsController extends ManageCampsController {
  @override
  Future<List<DonationCampEntry>> build() async => [];
}

void main() {
  testWidgets('lists camps with host and date', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          manageCampsControllerProvider.overrideWith(
            _FakeManageCampsController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ManageCampsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('City Blood Drive'), findsOneWidget);
    expect(find.text('Campus Drive'), findsOneWidget);
    expect(find.text('Hosted by City Blood Bank'), findsOneWidget);
    expect(find.text('Add new camp'), findsOneWidget);
  });

  testWidgets('shows empty state when there are no camps', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          manageCampsControllerProvider.overrideWith(
            _EmptyManageCampsController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ManageCampsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No donation camps yet'), findsOneWidget);
  });
}
