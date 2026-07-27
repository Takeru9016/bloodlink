import 'package:bloodlink/core/router/app_router.dart';
import 'package:bloodlink/core/router/auth_state.dart';
import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/features/donor_profile/presentation/donor_profile_setup_screen.dart';
import 'package:bloodlink/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpRouterFor(WidgetTester tester, AuthState auth) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authStateProvider.overrideWithValue(auth)],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          theme: AppTheme.light,
          routerConfig: ref.watch(appRouterProvider),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('signed out lands on onboarding', (tester) async {
    await _pumpRouterFor(tester, const AuthState.signedOut());
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets('signed in with no roles yet lands on donor profile setup', (
    tester,
  ) async {
    await _pumpRouterFor(
      tester,
      const AuthState.signedIn(uid: 'u1', roles: []),
    );
    expect(find.byType(DonorProfileSetupScreen), findsOneWidget);
  });

  testWidgets('signed in with donor role lands on consumer shell, not admin', (
    tester,
  ) async {
    await _pumpRouterFor(
      tester,
      const AuthState.signedIn(uid: 'u2', roles: ['donor']),
    );
    expect(find.text('Request'), findsOneWidget);
    expect(find.text('Partners'), findsNothing);
  });

  testWidgets(
    'signed in with requester role lands on consumer shell, not admin',
    (tester) async {
      await _pumpRouterFor(
        tester,
        const AuthState.signedIn(uid: 'u3', roles: ['requester']),
      );
      expect(find.text('Banks'), findsOneWidget);
      expect(find.text('Partners'), findsNothing);
    },
  );

  testWidgets('signed in with admin role lands on admin shell, not consumer', (
    tester,
  ) async {
    await _pumpRouterFor(
      tester,
      const AuthState.signedIn(uid: 'u4', roles: ['admin']),
    );
    expect(find.text('Partners'), findsOneWidget);
    expect(find.text('Request'), findsNothing);
  });

  testWidgets(
    'signed in with donor+admin roles still lands on admin shell, never the consumer bottom nav',
    (tester) async {
      await _pumpRouterFor(
        tester,
        const AuthState.signedIn(uid: 'u5', roles: ['donor', 'admin']),
      );
      expect(find.text('Partners'), findsOneWidget);
      expect(find.text('Request'), findsNothing);
    },
  );

  testWidgets('auth state still loading renders blank, no redirect guess', (
    tester,
  ) async {
    await _pumpRouterFor(tester, const AuthState.loading());
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(DonorProfileSetupScreen), findsNothing);
    expect(find.text('Request'), findsNothing);
    expect(find.text('Partners'), findsNothing);
  });
}
