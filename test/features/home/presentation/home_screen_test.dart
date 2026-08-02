import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/banner_item_model.dart';
import 'package:bloodlink/data/models/partner_model.dart';
import 'package:bloodlink/features/home/application/home_controller.dart';
import 'package:bloodlink/features/home/presentation/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

BannerItemModel _banner({String? linkedPartnerId}) {
  return BannerItemModel(
    imageUrl: 'https://example.com/banner.jpg',
    linkedPartnerId: linkedPartnerId,
    displayOrder: 0,
    active: true,
    createdBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

PartnerModel _partner(String name) {
  return PartnerModel(
    name: name,
    address: '123 Main St',
    location: const GeoPoint(0, 0),
    phone: '555-0100',
    verificationStatus: VerificationStatus.verified,
    updatedBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

class _FakeHomeController extends HomeController {
  _FakeHomeController(this._state);

  final HomeState _state;

  @override
  Future<HomeState> build() async => _state;
}

Widget _wrap(Widget child, {required HomeState state}) {
  return ProviderScope(
    overrides: [
      homeControllerProvider.overrideWith(() => _FakeHomeController(state)),
      unreadNotificationCountProvider.overrideWith((ref) => Stream.value(2)),
    ],
    child: MaterialApp(theme: AppTheme.light, home: child),
  );
}

void main() {
  testWidgets('renders carousel, quick actions, and trusted partners', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const HomeScreen(),
        state: (
          banners: [(id: 'b1', model: _banner())],
          trustedPartners: [(id: 'p1', partner: _partner('City Blood Bank'))],
          pendingNearbyCount: 3,
          locationStatus: HomeLocationStatus.available,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Request blood'), findsOneWidget);
    expect(find.text('Find bank'), findsOneWidget);
    expect(find.text('Donor list'), findsOneWidget);
    expect(find.text('City Blood Bank'), findsOneWidget);
    expect(find.text('3 pending blood requests near you'), findsOneWidget);
  });

  testWidgets('shows empty states for banners and trusted partners', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const HomeScreen(),
        state: (
          banners: const [],
          trustedPartners: const [],
          pendingNearbyCount: null,
          locationStatus: HomeLocationStatus.unavailable,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('No announcements right now'), findsOneWidget);
    expect(find.text('No verified partners yet'), findsOneWidget);
    expect(
      find.text(
        'Local demand unavailable — enable location to see nearby need',
      ),
      findsOneWidget,
    );
  });
}
