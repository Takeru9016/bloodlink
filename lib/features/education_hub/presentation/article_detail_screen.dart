import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../application/education_hub_controller.dart';

class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final articleAsync = ref.watch(educationArticleProvider(articleId));

    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: SafeArea(
        child: articleAsync.when(
          data: (article) {
            if (article == null) {
              return Center(
                child: Text(
                  'Article not found',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article.title, style: textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Text(article.body, style: textTheme.bodyLarge),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              const AppErrorView(message: "Couldn't load this article."),
        ),
      ),
    );
  }
}
