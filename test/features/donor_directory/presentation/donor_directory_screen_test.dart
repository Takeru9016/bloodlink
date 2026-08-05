import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/donor_profile_model.dart';
import 'package:bloodlink/data/models/report_model.dart';
import 'package:bloodlink/features/donor_directory/application/donor_directory_controller.dart';
import 'package:bloodlink/features/donor_directory/presentation/donor_directory_screen.dart';
import 'package:bloodlink/shared/widgets/report_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

DonorProfileModel _profile({required BloodGroup bloodGroup}) {
  return DonorProfileModel(
    bloodGroup: bloodGroup,
    dob: Timestamp.fromDate(DateTime(1995, 1, 1)),
    verificationStatus: VerificationStatus.verified,
    optInRadiusKm: 10,
  );
}

class _FakeDonorDirectoryController extends DonorDirectoryController {
  _FakeDonorDirectoryController(this._state);

  final DonorDirectoryState _state;

  @override
  Future<DonorDirectoryState> build() async => _state;
}

Future<void> _pump(WidgetTester tester, DonorDirectoryState state) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        donorDirectoryControllerProvider.overrideWith(
          () => _FakeDonorDirectoryController(state),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const DonorDirectoryScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('prompts to select a blood group before any query has run', (
    tester,
  ) async {
    await _pump(tester, (
      bloodGroup: null,
      radiusKm: null,
      entries: const <DonorDirectoryEntry>[],
      locationStatus: DonorDirectoryLocationStatus.available,
    ));

    expect(
      find.text('Select a blood group to see nearby verified donors.'),
      findsOneWidget,
    );
  });

  testWidgets('shows an empty state when no donors match the filters', (
    tester,
  ) async {
    await _pump(tester, (
      bloodGroup: 'O-',
      radiusKm: null,
      entries: const <DonorDirectoryEntry>[],
      locationStatus: DonorDirectoryLocationStatus.available,
    ));

    expect(find.text('No verified donors found for O-'), findsOneWidget);
  });

  testWidgets(
    'lists matching donors with blood group badge and distance, each with a report button',
    (tester) async {
      await _pump(tester, (
        bloodGroup: 'A+',
        radiusKm: 10,
        entries: [
          (
            id: 'donor-1',
            profile: _profile(bloodGroup: BloodGroup.aPositive),
            name: 'Asha Kumar',
            distanceMeters: 1500.0,
          ),
          (
            id: 'donor-2',
            profile: _profile(bloodGroup: BloodGroup.aPositive),
            name: 'Ravi Shah',
            distanceMeters: null,
          ),
        ],
        locationStatus: DonorDirectoryLocationStatus.available,
      ));

      expect(find.text('Asha Kumar'), findsOneWidget);
      expect(find.text('Ravi Shah'), findsOneWidget);
      expect(find.text('1.5 km away'), findsOneWidget);
      expect(find.text('Distance unavailable'), findsOneWidget);
      expect(find.text('A+'), findsNWidgets(2));

      final reportButtons = tester
          .widgetList<ReportButton>(find.byType(ReportButton))
          .toList();
      expect(reportButtons, hasLength(2));
      expect(reportButtons.map((b) => (b.targetType, b.targetId)).toSet(), {
        (ReportTargetType.donor, 'donor-1'),
        (ReportTargetType.donor, 'donor-2'),
      });
    },
  );
}
