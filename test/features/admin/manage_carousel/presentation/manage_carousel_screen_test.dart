import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/banner_item_model.dart';
import 'package:bloodlink/features/admin/manage_carousel/application/manage_carousel_controller.dart';
import 'package:bloodlink/features/admin/manage_carousel/presentation/manage_carousel_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

BannerItemModel _banner({required int displayOrder, required bool active}) {
  return BannerItemModel(
    imageUrl: 'https://example.com/banner.jpg',
    linkedPartnerId: null,
    displayOrder: displayOrder,
    active: active,
    createdBy: 'admin-uid',
    updatedBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

class _FakeManageCarouselController extends ManageCarouselController {
  @override
  Future<List<({String id, BannerItemModel model})>> build() async {
    return [
      (id: 'b1', model: _banner(displayOrder: 0, active: true)),
      (id: 'b2', model: _banner(displayOrder: 1, active: false)),
    ];
  }
}

class _EmptyManageCarouselController extends ManageCarouselController {
  @override
  Future<List<({String id, BannerItemModel model})>> build() async => [];
}

void main() {
  testWidgets('lists banners with active/inactive badges', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          manageCarouselControllerProvider.overrideWith(
            _FakeManageCarouselController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ManageCarouselScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Order 0'), findsOneWidget);
    expect(find.text('Order 1'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Inactive'), findsOneWidget);
    expect(find.text('Upload banner'), findsOneWidget);
  });

  testWidgets('shows empty state when there are no banners', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          manageCarouselControllerProvider.overrideWith(
            _EmptyManageCarouselController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ManageCarouselScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No banners yet'), findsOneWidget);
  });

  testWidgets(
    'disables the up arrow on the first row and down arrow on the last',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            manageCarouselControllerProvider.overrideWith(
              _FakeManageCarouselController.new,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const ManageCarouselScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final upButtons = tester.widgetList<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_upward),
      );
      final downButtons = tester.widgetList<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_downward),
      );

      expect(upButtons.first.onPressed, isNull);
      expect(downButtons.last.onPressed, isNull);
    },
  );
}
