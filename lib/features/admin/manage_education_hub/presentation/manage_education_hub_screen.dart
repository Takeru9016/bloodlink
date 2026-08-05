import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/education_article_model.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../application/manage_education_hub_controller.dart';

String _categoryLabel(EducationArticleCategory category) {
  return switch (category) {
    EducationArticleCategory.basics => 'Basics',
    EducationArticleCategory.eligibility => 'Eligibility',
    EducationArticleCategory.guidance => 'Guidance',
    EducationArticleCategory.faq => 'FAQ',
  };
}

class ManageEducationHubScreen extends ConsumerWidget {
  const ManageEducationHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final articlesAsync = ref.watch(manageEducationHubControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage education hub')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.adminEducationNewName),
        icon: const Icon(Icons.add),
        label: const Text('New article'),
      ),
      body: SafeArea(
        child: articlesAsync.when(
          data: (articles) {
            if (articles.isEmpty) {
              return Center(
                child: Text(
                  'No articles yet',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => ref
                  .read(manageEducationHubControllerProvider.notifier)
                  .refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: articles.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final record = articles[index];
                  return _ArticleRow(id: record.id, article: record.model);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load articles: $error')),
        ),
      ),
    );
  }
}

class _ArticleRow extends StatelessWidget {
  const _ArticleRow({required this.id, required this.article});

  final String id;
  final EducationArticleModel article;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title, style: textTheme.bodyLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    AppBadge(
                      label: _categoryLabel(article.category),
                      variant: AppBadgeVariant.off,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Order ${article.displayOrder}',
                      style: textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.goNamed(
              AppRoute.adminEducationEditName,
              pathParameters: {'articleId': id},
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}
