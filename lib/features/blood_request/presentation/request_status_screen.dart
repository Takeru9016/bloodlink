import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/blood_request_model.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/request_status_controller.dart';

class RequestStatusScreen extends ConsumerStatefulWidget {
  const RequestStatusScreen({super.key});

  @override
  ConsumerState<RequestStatusScreen> createState() =>
      _RequestStatusScreenState();
}

class _RequestStatusScreenState extends ConsumerState<RequestStatusScreen> {
  final Set<String> _pendingActionIds = {};

  Future<void> _handleAction({
    required String requestId,
    required BloodRequestStatus newStatus,
  }) async {
    setState(() => _pendingActionIds.add(requestId));

    final controller = ref.read(requestStatusControllerProvider.notifier);
    final succeeded = await controller.updateStatus(
      requestId: requestId,
      newStatus: newStatus,
    );

    if (!mounted) return;
    setState(() => _pendingActionIds.remove(requestId));

    if (!succeeded) {
      final error = ref.read(requestStatusControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update request: $error')),
      );
    }
  }

  static (String, AppBadgeVariant) _badgeFor(BloodRequestStatus status) {
    return switch (status) {
      BloodRequestStatus.pending => ('Pending', AppBadgeVariant.pending),
      BloodRequestStatus.matched => ('Matched', AppBadgeVariant.pending),
      BloodRequestStatus.fulfilled => ('Fulfilled', AppBadgeVariant.verified),
      BloodRequestStatus.cancelled => ('Cancelled', AppBadgeVariant.off),
      BloodRequestStatus.expired => ('Expired', AppBadgeVariant.off),
    };
  }

  static bool _isActionable(BloodRequestStatus status) {
    return status == BloodRequestStatus.pending ||
        status == BloodRequestStatus.matched;
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(requestStatusListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your requests')),
      body: SafeArea(
        child: entriesAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return const _CenteredMessage(
                message: 'You haven\'t submitted any blood requests yet.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = entries[index];
                final isPending = _pendingActionIds.contains(entry.id);
                return _RequestCard(
                  entry: entry,
                  badge: _badgeFor(entry.request.status),
                  isActionable: _isActionable(entry.request.status),
                  isLoading: isPending,
                  onMarkFulfilled: () => _handleAction(
                    requestId: entry.id,
                    newStatus: BloodRequestStatus.fulfilled,
                  ),
                  onCancel: () => _handleAction(
                    requestId: entry.id,
                    newStatus: BloodRequestStatus.cancelled,
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              _CenteredMessage(message: 'Failed to load requests: $error'),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.entry,
    required this.badge,
    required this.isActionable,
    required this.isLoading,
    required this.onMarkFulfilled,
    required this.onCancel,
  });

  final RequestStatusEntry entry;
  final (String, AppBadgeVariant) badge;
  final bool isActionable;
  final bool isLoading;
  final VoidCallback onMarkFulfilled;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final request = entry.request;
    final (label, variant) = badge;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(request.patientName, style: textTheme.bodyLarge),
              ),
              AppBadge(label: label, variant: variant),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${request.units} unit(s) of ${request.bloodGroup}',
            style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
          Text(
            request.hospital,
            style: textTheme.labelSmall?.copyWith(color: colors.textSecondary),
          ),
          if (isActionable) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Mark fulfilled',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : onMarkFulfilled,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.outline,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : onCancel,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}
