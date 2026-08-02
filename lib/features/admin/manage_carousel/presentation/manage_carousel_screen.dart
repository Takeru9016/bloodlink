import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/banner_item_model.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../application/manage_carousel_controller.dart';

class ManageCarouselScreen extends ConsumerWidget {
  const ManageCarouselScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final bannersAsync = ref.watch(manageCarouselControllerProvider);

    ref.listen(manageCarouselControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Action failed: $error')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Manage home carousel')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.adminCarouselNewName),
        icon: const Icon(Icons.add),
        label: const Text('Upload banner'),
      ),
      body: SafeArea(
        child: bannersAsync.when(
          data: (banners) {
            if (banners.isEmpty) {
              return Center(
                child: Text(
                  'No banners yet',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(manageCarouselControllerProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: banners.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final record = banners[index];
                  return _BannerRow(
                    id: record.id,
                    banner: record.model,
                    isFirst: index == 0,
                    isLast: index == banners.length - 1,
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load banners: $error')),
        ),
      ),
    );
  }
}

class _BannerRow extends ConsumerWidget {
  const _BannerRow({
    required this.id,
    required this.banner,
    required this.isFirst,
    required this.isLast,
  });

  final String id;
  final BannerItemModel banner;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final controllerState = ref.watch(manageCarouselControllerProvider);
    final isBusy = controllerState.isLoading;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Image.network(
              banner.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 64,
                height: 64,
                color: Theme.of(context).extension<AppColors>()!.surfaceMuted,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Order ${banner.displayOrder}',
                        style: textTheme.bodyLarge,
                      ),
                    ),
                    AppBadge(
                      label: banner.active ? 'Active' : 'Inactive',
                      variant: banner.active
                          ? AppBadgeVariant.verified
                          : AppBadgeVariant.off,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: isFirst || isBusy
                          ? null
                          : () => ref
                                .read(manageCarouselControllerProvider.notifier)
                                .moveUp(id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: isLast || isBusy
                          ? null
                          : () => ref
                                .read(manageCarouselControllerProvider.notifier)
                                .moveDown(id),
                    ),
                    const Spacer(),
                    Switch(
                      value: banner.active,
                      onChanged: isBusy
                          ? null
                          : (value) => ref
                                .read(manageCarouselControllerProvider.notifier)
                                .toggleActive(id, value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
