import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/donation_camp_model.dart';
import 'package:bloodlink/features/camps/application/camp_listing_controller.dart';
import 'package:bloodlink/features/camps/presentation/camp_listing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

DonationCampModel _camp({required String name, required DateTime date}) {
  return DonationCampModel(
    name: name,
    description: 'Description for $name',
    location: const GeoPoint(0, 0),
    date: Timestamp.fromDate(date),
    hostName: 'Host of $name',
    createdBy: 'admin-uid',
    updatedBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

class _FakeCampListingController extends CampListingController {
  @override
  Future<CampListingState> build() async {
    return (
      entries: [
        (
          id: 'c1',
          camp: _camp(name: 'Camp Alpha', date: DateTime(2026, 9, 1)),
          distanceMeters: 1200.0,
        ),
        (
          id: 'c2',
          camp: _camp(name: 'Camp Beta', date: DateTime(2026, 9, 5)),
          distanceMeters: null,
        ),
      ],
      locationStatus: CampLocationStatus.available,
    );
  }
}

class _EmptyCampListingController extends CampListingController {
  @override
  Future<CampListingState> build() async => (
    entries: <CampListingEntry>[],
    locationStatus: CampLocationStatus.available,
  );
}

void main() {
  testWidgets('lists upcoming camps with host and distance', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          campListingControllerProvider.overrideWith(
            _FakeCampListingController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const CampListingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Camp Alpha'), findsOneWidget);
    expect(find.text('Camp Beta'), findsOneWidget);
    expect(find.text('Hosted by Host of Camp Alpha'), findsOneWidget);
    expect(find.text('1.2 km away'), findsOneWidget);
    expect(find.text('Distance unavailable'), findsOneWidget);
  });

  testWidgets('shows empty state when there are no upcoming camps', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          campListingControllerProvider.overrideWith(
            _EmptyCampListingController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const CampListingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No upcoming camps'), findsOneWidget);
  });
}
