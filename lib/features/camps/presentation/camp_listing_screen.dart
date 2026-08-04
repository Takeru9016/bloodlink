import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/camp_listing_controller.dart';

String _formatDate(Timestamp timestamp) {
  final date = timestamp.toDate().toLocal();
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

String _formatDistance(double? meters) {
  if (meters == null) return 'Distance unavailable';
  if (meters < 1000) return '${meters.round()} m away';
  return '${(meters / 1000).toStringAsFixed(1)} km away';
}

class CampListingScreen extends ConsumerWidget {
  const CampListingScreen({super.key});

  void _openCamp(BuildContext context, String campId) {
    context.pushNamed(
      AppRoute.campDetailName,
      pathParameters: {'campId': campId},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final stateAsync = ref.watch(campListingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Donation camps')),
      body: SafeArea(
        child: stateAsync.when(
          data: (state) {
            if (state.entries.isEmpty) {
              return Center(
                child: Text(
                  'No upcoming camps',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(campListingControllerProvider.notifier).refresh(),
              child: Column(
                children: [
                  if (state.locationStatus == CampLocationStatus.resolving)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        children: [
                          const SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Finding your location…',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      itemCount: state.entries.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final entry = state.entries[index];
                        return AppCard(
                          onTap: () => _openCamp(context, entry.id),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.camp.name, style: textTheme.bodyLarge),
                              const SizedBox(height: 4),
                              Text(
                                'Hosted by ${entry.camp.hostName}',
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(entry.camp.date),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDistance(entry.distanceMeters),
                                style: textTheme.labelSmall,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Failed to load donation camps: $error',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
