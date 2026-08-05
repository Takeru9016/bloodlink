import 'dart:async';

import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/report_model.dart';
import 'package:bloodlink/data/models/user_model.dart';
import 'package:bloodlink/features/admin/moderation/application/moderation_controller.dart';
import 'package:bloodlink/features/admin/moderation/presentation/moderation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ReportModel _report({
  required ReportTargetType targetType,
  required String reporterId,
}) {
  return ReportModel(
    reporterId: reporterId,
    targetType: targetType,
    targetId: 'target-1',
    reason: 'Inappropriate behavior',
    status: ReportStatus.open,
    createdAt: Timestamp.now(),
  );
}

UserModel _user(String name) {
  return UserModel(
    name: name,
    email: 'user@example.com',
    roles: const ['donor'],
    createdAt: Timestamp.now(),
  );
}

class _FakeModerationController extends ModerationController {
  final List<String> resolved = [];
  final List<String> dismissed = [];

  @override
  FutureOr<void> build() {}

  @override
  Future<void> resolve(String reportId) async {
    resolved.add(reportId);
  }

  @override
  Future<void> dismiss(String reportId) async {
    dismissed.add(reportId);
  }
}

void main() {
  testWidgets('shows empty state when there are no open reports', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [openReportsProvider.overrideWith((ref) async => [])],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ModerationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No open reports'), findsOneWidget);
  });

  testWidgets(
    'lists open reports with reporter name, target type, and reason',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            openReportsProvider.overrideWith(
              (ref) async => [
                (
                  id: 'r1',
                  model: _report(
                    targetType: ReportTargetType.donor,
                    reporterId: 'reporter-1',
                  ),
                ),
              ],
            ),
            reportUserProvider(
              'reporter-1',
            ).overrideWith((ref) async => _user('Asha Kumar')),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const ModerationScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Donor'), findsOneWidget);
      expect(find.text('Reported by Asha Kumar'), findsOneWidget);
      expect(find.text('Target ID: target-1'), findsOneWidget);
      expect(find.text('Inappropriate behavior'), findsOneWidget);
      expect(find.text('Resolve'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);
    },
  );

  testWidgets('tapping Resolve/Dismiss calls the controller with report id', (
    tester,
  ) async {
    final fakeController = _FakeModerationController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          openReportsProvider.overrideWith(
            (ref) async => [
              (
                id: 'r1',
                model: _report(
                  targetType: ReportTargetType.partner,
                  reporterId: 'reporter-1',
                ),
              ),
              (
                id: 'r2',
                model: _report(
                  targetType: ReportTargetType.request,
                  reporterId: 'reporter-2',
                ),
              ),
            ],
          ),
          reportUserProvider(
            'reporter-1',
          ).overrideWith((ref) async => _user('Reporter One')),
          reportUserProvider(
            'reporter-2',
          ).overrideWith((ref) async => _user('Reporter Two')),
          moderationControllerProvider.overrideWith(() => fakeController),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ModerationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Resolve').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dismiss').last);
    await tester.pumpAndSettle();

    expect(fakeController.resolved, ['r1']);
    expect(fakeController.dismissed, ['r2']);
  });
}
