import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../application/manage_camps_controller.dart';

String _formatDate(Timestamp timestamp) {
  final date = timestamp.toDate().toLocal();
  final datePart =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
  final timePart =
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
  return '$datePart at $timePart';
}

class ManageCampsScreen extends ConsumerWidget {
  const ManageCampsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final campsAsync = ref.watch(manageCampsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage camps')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.adminCampNewName),
        icon: const Icon(Icons.add),
        label: const Text('Add new camp'),
      ),
      body: SafeArea(
        child: campsAsync.when(
          data: (camps) {
            if (camps.isEmpty) {
              return Center(
                child: Text(
                  'No donation camps yet',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(manageCampsControllerProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: camps.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final record = camps[index];
                  return AppCard(
                    onTap: () => context.goNamed(
                      AppRoute.adminCampEditName,
                      pathParameters: {'campId': record.id},
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(record.camp.name, style: textTheme.bodyLarge),
                        const SizedBox(height: 4),
                        Text(
                          'Hosted by ${record.camp.hostName}',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(record.camp.date),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load camps: $error')),
        ),
      ),
    );
  }
}
