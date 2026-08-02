import 'package:bloodlink/core/theme/app_theme.dart';
import 'package:bloodlink/data/models/education_article_model.dart';
import 'package:bloodlink/features/education_hub/application/education_hub_controller.dart';
import 'package:bloodlink/features/education_hub/presentation/article_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders article title and body', (tester) async {
    final article = EducationArticleModel(
      title: 'Why donate blood?',
      body: 'Donating blood helps people in emergencies.',
      category: EducationArticleCategory.basics,
      displayOrder: 0,
      updatedBy: 'admin-uid',
      updatedAt: Timestamp.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          educationArticleProvider('a1').overrideWith((ref) async => article),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ArticleDetailScreen(articleId: 'a1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Why donate blood?'), findsOneWidget);
    expect(
      find.text('Donating blood helps people in emergencies.'),
      findsOneWidget,
    );
  });

  testWidgets('shows not-found message when article is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          educationArticleProvider('missing').overrideWith((ref) async => null),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ArticleDetailScreen(articleId: 'missing'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Article not found'), findsOneWidget);
  });
}
