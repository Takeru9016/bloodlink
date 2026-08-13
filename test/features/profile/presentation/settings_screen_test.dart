import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/donor_profile_model.dart';
import 'package:bloodlink/data/models/user_model.dart';
import 'package:bloodlink/features/profile/application/settings_controller.dart';
import 'package:bloodlink/features/profile/presentation/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

UserModel _user({String? phone}) {
  return UserModel(
    name: 'Asha Verma',
    email: 'asha@example.com',
    phone: phone,
    roles: const ['donor'],
    createdAt: Timestamp.now(),
  );
}

DonorProfileModel _donorProfile({double optInRadiusKm = 15}) {
  return DonorProfileModel(
    bloodGroup: BloodGroup.oPositive,
    dob: Timestamp.now(),
    verificationStatus: VerificationStatus.verified,
    optInRadiusKm: optInRadiusKm,
  );
}

class _FakeSettingsController extends SettingsController {
  _FakeSettingsController(this._state);

  final SettingsState _state;

  @override
  Future<SettingsState> build() async => _state;
}

Widget _wrap(SettingsState state) {
  return ProviderScope(
    overrides: [
      settingsControllerProvider.overrideWith(
        () => _FakeSettingsController(state),
      ),
    ],
    child: MaterialApp(theme: AppTheme.light, home: const SettingsScreen()),
  );
}

// SettingsScreen's redesigned (taller capsule buttons/filled inputs) content
// exceeds the test binding's default viewport, and ListView's Sliver
// machinery only builds children within the viewport + cache extent — even
// for the non-`.builder` constructor. A real device just scrolls; the test
// needs a tall enough surface for _NearbyAlertsSection to be built at all.
void _useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(400, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('renders account info and nearby-alert radius for a donor', (
    tester,
  ) async {
    _useTallSurface(tester);
    await tester.pumpWidget(
      _wrap((
        profile: (
          user: _user(phone: '9998887777'),
          isDonor: true,
          donorProfile: _donorProfile(),
        ),
        pushEnabled: true,
      )),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Asha Verma'), findsOneWidget);
    expect(find.text('asha@example.com'), findsOneWidget);
    expect(find.text('Enabled'), findsOneWidget);
    expect(find.text('Nearby request alerts'), findsOneWidget);
    expect(find.text('Off'), findsOneWidget);
    expect(find.text('15 km'), findsOneWidget);
  });

  testWidgets('shows Enable button and no radius picker for a non-donor', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap((
        profile: (user: _user(), isDonor: false, donorProfile: null),
        pushEnabled: false,
      )),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Not enabled'), findsOneWidget);
    expect(find.text('Enable'), findsOneWidget);
    expect(find.text('Nearby request alerts'), findsNothing);
  });

  testWidgets(
    'prompts a donor-role user with no donor profile to finish setup',
    (tester) async {
      _useTallSurface(tester);
      await tester.pumpWidget(
        _wrap((
          profile: (user: _user(), isDonor: true, donorProfile: null),
          pushEnabled: true,
        )),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Nearby request alerts'), findsOneWidget);
      expect(find.text('Set up donor profile'), findsOneWidget);
      expect(find.text('Off'), findsNothing);
    },
  );
}
