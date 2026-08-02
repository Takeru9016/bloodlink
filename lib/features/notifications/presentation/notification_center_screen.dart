import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/notification_center_controller.dart';

const _monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _formatTime(DateTime local) {
  final hour24 = local.hour;
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final period = hour24 < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}

String _formatDate(DateTime local) {
  return '${_monthAbbreviations[local.month - 1]} ${local.day}';
}

String _capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';

const _urgencyLabels = {
  '2h': 'Within 2 hours',
  '6h': 'Within 6 hours',
  '24h': 'Within 24 hours',
  '1w': 'Within a week',
};

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  Future<void> _handleTap(WidgetRef ref, NotificationEntry entry) async {
    if (!entry.model.readStatus) {
      await ref
          .read(notificationCenterControllerProvider.notifier)
          .markAsRead(entry.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(notificationCenterListProvider);
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: SafeArea(
        child: listAsync.when(
          data: (state) {
            if (state.today.isEmpty && state.earlier.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No notifications yet.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (state.today.isNotEmpty) ...[
                  _SectionHeader(label: 'Today'),
                  const SizedBox(height: 8),
                  for (final entry in state.today) ...[
                    _NotificationTile(
                      entry: entry,
                      onTap: () => _handleTap(ref, entry),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
                if (state.earlier.isNotEmpty) ...[
                  if (state.today.isNotEmpty) const SizedBox(height: 8),
                  _SectionHeader(label: 'Earlier'),
                  const SizedBox(height: 8),
                  for (final entry in state.earlier) ...[
                    _NotificationTile(
                      entry: entry,
                      onTap: () => _handleTap(ref, entry),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Failed to load notifications: $error',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: colors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Renders a single notification's icon/title/subtitle by `type`. Every type
/// 2A-7's Cloud Functions actually emit ("request_nearby", "request_status")
/// must have a case below — an unhandled type trips the assert in debug so
/// the gap is caught during development, and falls back to a generic,
/// non-crashing tile in release so a genuinely new/unexpected type never
/// takes the screen down for a real user.
class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.entry, required this.onTap});

  final NotificationEntry entry;
  final VoidCallback onTap;

  (IconData, String, String, String?) _content() {
    final model = entry.model;
    final payload = model.payload;

    switch (model.type) {
      case 'request_status':
        final status = payload['status'] as String? ?? 'updated';
        return (
          Icons.bloodtype_outlined,
          'Your blood request update',
          'Now: ${_capitalize(status)}',
          AppRoute.requestStatusName,
        );
      case 'request_nearby':
        final bloodGroup = payload['bloodGroup'] as String? ?? '';
        final hospital = payload['hospital'] as String? ?? '';
        final urgency = payload['urgencyWindow'] as String?;
        final urgencyLabel = _urgencyLabels[urgency] ?? urgency ?? '';
        return (
          Icons.campaign_outlined,
          'Blood needed nearby',
          [
            if (bloodGroup.isNotEmpty) bloodGroup,
            if (hospital.isNotEmpty) hospital,
            if (urgencyLabel.isNotEmpty) urgencyLabel,
          ].join(' · '),
          // Placeholder destination — see CLAUDE.md §7: there's no
          // donor-facing request-detail screen yet, so this routes to the
          // generic Bank locator rather than the specific matched request.
          AppRoute.banksName,
        );
      default:
        assert(
          false,
          'Unhandled notification type "${model.type}" — add a case in '
          'notification_center_screen.dart before this type ships.',
        );
        return (
          Icons.notifications_none,
          'Notification',
          'type: ${model.type}',
          null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final model = entry.model;
    final createdAtLocal = model.createdAt.toDate().toLocal();
    final now = DateTime.now();
    final isToday =
        createdAtLocal.year == now.year &&
        createdAtLocal.month == now.month &&
        createdAtLocal.day == now.day;
    final timeLabel = isToday
        ? _formatTime(createdAtLocal)
        : _formatDate(createdAtLocal);
    final (icon, title, subtitle, routeName) = _content();
    final isUnread = !model.readStatus;

    return AppCard(
      onTap: () {
        onTap();
        if (routeName != null) {
          context.goNamed(routeName);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnread ? colors.brandRed : Colors.transparent,
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: colors.textSecondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: isUnread ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            timeLabel,
            style: textTheme.labelSmall?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
