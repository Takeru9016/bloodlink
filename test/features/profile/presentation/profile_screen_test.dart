import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/donor_profile_model.dart';
import 'package:bloodlink/data/models/user_model.dart';
import 'package:bloodlink/features/profile/application/profile_controller.dart';
import 'package:bloodlink/features/profile/presentation/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

UserModel _user() {
  return UserModel(
    name: 'Asha Verma',
    email: 'asha@example.com',
    roles: const ['donor'],
    createdAt: Timestamp.now(),
  );
}

DonorProfileModel _donorProfile({
  VerificationStatus status = VerificationStatus.verified,
}) {
  return DonorProfileModel(
    bloodGroup: BloodGroup.oPositive,
    dob: Timestamp.now(),
    verificationStatus: status,
    optInRadiusKm: 10,
  );
}

class _FakeProfileController extends ProfileController {
  _FakeProfileController(this._state);

  final ProfileState _state;

  @override
  Future<ProfileState> build() async => _state;
}

Widget _wrap(ProfileState state) {
  return ProviderScope(
    overrides: [
      profileControllerProvider.overrideWith(
        () => _FakeProfileController(state),
      ),
    ],
    child: MaterialApp(theme: AppTheme.light, home: const ProfileScreen()),
  );
}

void main() {
  testWidgets('renders donor profile with honest not-tracked-yet stats', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap((user: _user(), isDonor: true, donorProfile: _donorProfile())),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Asha Verma'), findsOneWidget);
    expect(find.text('O+'), findsOneWidget);
    expect(find.text('Verified donor'), findsOneWidget);
    expect(find.text('Not tracked yet'), findsNWidgets(3));
    expect(find.text('Lives saved'), findsOneWidget);
    expect(find.text('Donations'), findsOneWidget);
    expect(find.text('Rating'), findsOneWidget);
    expect(find.text('Donation history'), findsOneWidget);
    expect(find.text('Badges'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Help & support'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });

  testWidgets('prompts donor-role user with no donor profile to finish setup', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap((user: _user(), isDonor: true, donorProfile: null)),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Finish setting up your donor profile'), findsOneWidget);
    expect(find.text('O+'), findsNothing);
  });

  testWidgets('omits donor section entirely for a non-donor user', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap((user: _user(), isDonor: false, donorProfile: null)),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Finish setting up your donor profile'), findsNothing);
    expect(find.text('O+'), findsNothing);
  });
}
