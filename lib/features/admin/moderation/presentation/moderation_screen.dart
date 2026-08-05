import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/report_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../application/moderation_controller.dart';

const _targetTypeLabels = {
  ReportTargetType.request: 'Blood request',
  ReportTargetType.donor: 'Donor',
  ReportTargetType.partner: 'Partner listing',
};

class ModerationScreen extends ConsumerWidget {
  const ModerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final reportsAsync = ref.watch(openReportsProvider);

    ref.listen(moderationControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Action failed: $error')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Moderation')),
      body: SafeArea(
        child: reportsAsync.when(
          data: (reports) {
            if (reports.isEmpty) {
              return Center(
                child: Text(
                  'No open reports',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: reports.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final record = reports[index];
                return _ReportCard(id: record.id, report: record.model);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load reports: $error')),
        ),
      ),
    );
  }
}

class _ReportCard extends ConsumerWidget {
  const _ReportCard({required this.id, required this.report});

  final String id;
  final ReportModel report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final reporterAsync = ref.watch(reportUserProvider(report.reporterId));
    final controllerState = ref.watch(moderationControllerProvider);
    final isBusy = controllerState.isLoading;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _targetTypeLabels[report.targetType] ?? 'Unknown',
                  style: textTheme.bodyLarge,
                ),
              ),
              Text(
                'Reported by ${reporterAsync.when(data: (user) => user?.name ?? report.reporterId, loading: () => report.reporterId, error: (_, _) => report.reporterId)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Target ID: ${report.targetId}', style: textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(report.reason, style: textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Dismiss',
                  variant: AppButtonVariant.outline,
                  isLoading: isBusy,
                  onPressed: () => ref
                      .read(moderationControllerProvider.notifier)
                      .dismiss(id),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Resolve',
                  isLoading: isBusy,
                  onPressed: () => ref
                      .read(moderationControllerProvider.notifier)
                      .resolve(id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
