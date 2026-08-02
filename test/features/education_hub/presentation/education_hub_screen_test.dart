import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/education_article_model.dart';
import 'package:bloodlink/features/education_hub/application/education_hub_controller.dart';
import 'package:bloodlink/features/education_hub/presentation/education_hub_screen.dart';
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
    body: 'Body for $title',
    category: category,
    displayOrder: displayOrder,
    updatedBy: 'admin-uid',
    updatedAt: Timestamp.now(),
  );
}

class _FakeEducationHubController extends EducationHubController {
  @override
  Future<List<EducationArticleEntry>> build() async {
    return [
      (
        id: 'a1',
        model: _article('Basics 1', EducationArticleCategory.basics, 0),
      ),
      (
        id: 'a2',
        model: _article('Basics 2', EducationArticleCategory.basics, 1),
      ),
      (
        id: 'a3',
        model: _article(
          'Eligibility 1',
          EducationArticleCategory.eligibility,
          0,
        ),
      ),
    ];
  }
}

class _EmptyEducationHubController extends EducationHubController {
  @override
  Future<List<EducationArticleEntry>> build() async => [];
}

void main() {
  testWidgets(
    'groups articles by category with no headers for empty categories',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            educationHubControllerProvider.overrideWith(
              _FakeEducationHubController.new,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const EducationHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // "Basics"/"Eligibility" each appear twice: once as a filter chip,
      // once as a section header (since both categories have articles).
      expect(find.text('Basics'), findsNWidgets(2));
      expect(find.text('Eligibility'), findsNWidgets(2));
      // "Guidance"/"FAQ" have no articles, so only the chip renders — no
      // section header for an empty category.
      expect(find.widgetWithText(ChoiceChip, 'Guidance'), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, 'FAQ'), findsOneWidget);
      expect(find.text('Basics 1'), findsOneWidget);
      expect(find.text('Basics 2'), findsOneWidget);
      expect(find.text('Eligibility 1'), findsOneWidget);
    },
  );

  testWidgets(
    'filtering to a category with articles shows only that category',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            educationHubControllerProvider.overrideWith(
              _FakeEducationHubController.new,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const EducationHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Eligibility'));
      await tester.pumpAndSettle();

      expect(find.text('Eligibility 1'), findsOneWidget);
      expect(find.text('Basics 1'), findsNothing);
      expect(find.text('Basics 2'), findsNothing);
    },
  );

  testWidgets(
    'filtering to a category with zero articles shows an empty state',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            educationHubControllerProvider.overrideWith(
              _FakeEducationHubController.new,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const EducationHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The chip must still be present even though "FAQ" has no articles.
      final faqChip = find.text('FAQ');
      expect(faqChip, findsOneWidget);

      await tester.tap(faqChip);
      await tester.pumpAndSettle();

      expect(find.text('No articles in this category yet'), findsOneWidget);
    },
  );

  testWidgets('shows empty state when there are no articles at all', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          educationHubControllerProvider.overrideWith(
            _EmptyEducationHubController.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const EducationHubScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No articles yet'), findsOneWidget);
  });
}
