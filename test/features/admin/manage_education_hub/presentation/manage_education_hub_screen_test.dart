import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/education_article_model.dart';
import 'package:bloodlink/features/admin/manage_education_hub/application/manage_education_hub_controller.dart';
import 'package:bloodlink/features/admin/manage_education_hub/presentation/manage_education_hub_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

EducationArticleModel _article(
  String title,
  EducationArticleCategory category,
  int displayOrder,
) {
  return EducationArticleModel(
    title: title,
    body: 'Body text.',
    category: category,
    displayOrder: displayOrder,
    updatedBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

class _FakeManageEducationHubController extends ManageEducationHubController {
  @override
  Future<List<({String id, EducationArticleModel model})>> build() async {
    return [
      (
        id: 'a1',
        model: _article('What is blood?', EducationArticleCategory.basics, 1),
      ),
      (
        id: 'a2',
        model: _article(
          'Am I eligible to donate?',
          EducationArticleCategory.eligibility,
          2,
        ),
      ),
    ];
  }
}

class _EmptyManageEducationHubController extends ManageEducationHubController {
  @override
  Future<List<({String id, EducationArticleModel model})>> build() async => [];
}

void main() {
  testWidgets('lists articles with category and display order', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          manageEducationHubControllerProvider.overrideWith(
            _FakeManageEducationHubController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ManageEducationHubScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('What is blood?'), findsOneWidget);
    expect(find.text('Am I eligible to donate?'), findsOneWidget);
    expect(find.text('Basics'), findsOneWidget);
    expect(find.text('Eligibility'), findsOneWidget);
    expect(find.text('Order 1'), findsOneWidget);
    expect(find.text('Order 2'), findsOneWidget);
    expect(find.text('New article'), findsOneWidget);
    expect(find.text('Edit'), findsNWidgets(2));
  });

  testWidgets('shows empty state when there are no articles', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          manageEducationHubControllerProvider.overrideWith(
            _EmptyManageEducationHubController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ManageEducationHubScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No articles yet'), findsOneWidget);
  });
}
