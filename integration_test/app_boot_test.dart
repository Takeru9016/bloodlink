import 'package:bloodlink/features/onboarding/presentation/onboarding_screen.dart';
import 'package:bloodlink/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'app boots against real Firebase (bloodlink-dev-wt) and reaches a real screen',
    (tester) async {
      // Runs the actual lib/main.dart entrypoint on a real device/emulator —
      // real Firebase.initializeApp, real router, real FCM/Crashlytics
      // wiring, none of it overridden. This is the check CLAUDE.md's own
      // history says analyze/test alone can't stand in for: 22 completed
      // tasks once shipped with lib/main.dart still on the unmodified
      // `flutter create` counter template (see CLAUDE.md line 110), because
      // neither `flutter analyze` nor a widget test that pumps an
      // override-heavy MyApp ever exercised the real entrypoint.
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(tester.takeException(), isNull);
      expect(find.byType(OnboardingScreen), findsOneWidget);
    },
  );
}
