import 'dart:async';

import 'package:bloodlink/core/router/auth_state.dart';
import 'package:bloodlink/features/notifications/application/fcm_controller.dart';
import 'package:bloodlink/features/onboarding/presentation/onboarding_screen.dart';
import 'package:bloodlink/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// FcmController's real build() talks to the Firebase Messaging plugin, which
// isn't available in a widget test — this stand-in isolates the boot check
// from that native dependency.
class _NoopFcmController extends FcmController {
  @override
  FutureOr<void> build() {}
}

void main() {
  testWidgets('MyApp boots and reaches a real screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWithValue(const AuthState.signedOut()),
          fcmControllerProvider.overrideWith(_NoopFcmController.new),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
