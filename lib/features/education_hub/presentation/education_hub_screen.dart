import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/education_article_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/education_hub_controller.dart';

const _categoryLabels = {
  EducationArticleCategory.basics: 'Basics',
  EducationArticleCategory.eligibility: 'Eligibility',
  EducationArticleCategory.guidance: 'Guidance',
  EducationArticleCategory.faq: 'FAQ',
};

class EducationHubScreen extends ConsumerStatefulWidget {
  const EducationHubScreen({super.key});

  @override
  ConsumerState<EducationHubScreen> createState() => _EducationHubScreenState();
}

class _EducationHubScreenState extends ConsumerState<EducationHubScreen> {
  EducationArticleCategory? _selectedCategory;

  void _openArticle(String articleId) {
    context.goNamed(
      AppRoute.educationArticleName,
      pathParameters: {'articleId': articleId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final articlesAsync = ref.watch(educationHubControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Education hub')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(
                      label: 'All',
                      selected: _selectedCategory == null,
                      onSelected: () =>
                          setState(() => _selectedCategory = null),
                    ),
                    for (final category in EducationArticleCategory.values)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _CategoryChip(
                          label: _categoryLabels[category]!,
                          selected: _selectedCategory == category,
                          onSelected: () =>
                              setState(() => _selectedCategory = category),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: articlesAsync.when(
                data: (entries) => _ArticleList(
                  entries: entries,
                  selectedCategory: _selectedCategory,
                  onTapArticle: _openArticle,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load articles: $error',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleList extends StatelessWidget {
  const _ArticleList({
    required this.entries,
    required this.selectedCategory,
    required this.onTapArticle,
  });

  final List<EducationArticleEntry> entries;
  final EducationArticleCategory? selectedCategory;
  final void Function(String articleId) onTapArticle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;

    // A single category selection flattens to that category's articles only.
    if (selectedCategory != null) {
      final filtered = entries
          .where((e) => e.model.category == selectedCategory)
          .toList();
      if (filtered.isEmpty) {
        return Center(
          child: Text(
            'No articles in this category yet',
            style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
          ),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: filtered.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _ArticleCard(entry: filtered[index], onTap: onTapArticle),
      );
    }

    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No articles yet',
          style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
        ),
      );
    }

    // Grouped view: a category with no articles simply has no section here.
    final children = <Widget>[];
    for (final category in EducationArticleCategory.values) {
      final group = entries.where((e) => e.model.category == category).toList();
      if (group.isEmpty) continue;
      if (children.isNotEmpty) children.add(const SizedBox(height: 20));
      children.add(
        Text(_categoryLabels[category]!, style: textTheme.titleLarge),
      );
      children.add(const SizedBox(height: 8));
      for (final entry in group) {
        children.add(_ArticleCard(entry: entry, onTap: onTapArticle));
        children.add(const SizedBox(height: 12));
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: children,
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.entry, required this.onTap});

  final EducationArticleEntry entry;
  final void Function(String articleId) onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => onTap(entry.id),
      child: Text(
        entry.model.title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: colors.brandRed,
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: selected ? colors.surface : colors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: colors.surfaceMuted,
      side: BorderSide(color: colors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
    );
  }
}
