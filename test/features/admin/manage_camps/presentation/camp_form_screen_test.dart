import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/features/admin/manage_camps/presentation/camp_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('create mode shows required-field validation errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppTheme.light, home: const CampFormScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final submitButton = find.widgetWithText(ElevatedButton, 'Add camp');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Description is required'), findsOneWidget);
    expect(find.text('Host name is required'), findsOneWidget);
  });
}
