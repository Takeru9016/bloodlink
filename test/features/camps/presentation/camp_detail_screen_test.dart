import 'dart:async';

import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/donation_camp_model.dart';
import 'package:bloodlink/features/camps/application/camp_detail_controller.dart';
import 'package:bloodlink/features/camps/presentation/camp_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _campId = 'camp-1';

DonationCampModel _camp() {
  return DonationCampModel(
    name: 'Camp Alpha',
    description: 'A great camp',
    location: const GeoPoint(0, 0),
    date: Timestamp.fromDate(DateTime(2026, 9, 1, 10)),
    hostName: 'Test Host',
    createdBy: 'admin-uid',
    updatedBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

class _FakeCampRsvpController extends CampRsvpController {
  _FakeCampRsvpController({required this.onToggle});

  final void Function(bool isRsvped) onToggle;

  @override
  FutureOr<void> build() {}

  @override
  Future<bool> toggle({required String campId, required bool isRsvped}) async {
    onToggle(isRsvped);
    return true;
  }
}

Future<void> _pump(
  WidgetTester tester, {
  required bool isRsvped,
  required int rsvpCount,
  void Function(bool isRsvped)? onToggle,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        campDetailProvider(_campId).overrideWith((ref) async => _camp()),
        campRsvpCountProvider(
          _campId,
        ).overrideWith((ref) => Stream.value(rsvpCount)),
        campRsvpStatusProvider(
          _campId,
        ).overrideWith((ref) => Stream.value(isRsvped)),
        campRsvpControllerProvider.overrideWith(
          () => _FakeCampRsvpController(onToggle: onToggle ?? (_) {}),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const CampDetailScreen(campId: _campId),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows camp details and live rsvp count', (tester) async {
    await _pump(tester, isRsvped: false, rsvpCount: 3);

    expect(find.text('Camp Alpha'), findsOneWidget);
    expect(find.text('Hosted by Test Host'), findsOneWidget);
    expect(find.text('A great camp'), findsOneWidget);
    expect(find.text("3 people have RSVP'd"), findsOneWidget);
    expect(find.text('RSVP'), findsOneWidget);
  });

  testWidgets('shows "Cancel RSVP" when the user has already rsvped', (
    tester,
  ) async {
    await _pump(tester, isRsvped: true, rsvpCount: 1);

    expect(find.text("1 person has RSVP'd"), findsOneWidget);
    expect(find.text('Cancel RSVP'), findsOneWidget);
    expect(find.text('RSVP'), findsNothing);
  });

  testWidgets('tapping RSVP calls the controller with the current state', (
    tester,
  ) async {
    bool? toggledWith;
    await _pump(
      tester,
      isRsvped: false,
      rsvpCount: 0,
      onToggle: (isRsvped) => toggledWith = isRsvped,
    );

    await tester.tap(find.text('RSVP'));
    await tester.pumpAndSettle();

    expect(toggledWith, false);
  });
}
