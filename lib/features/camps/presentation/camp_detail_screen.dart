import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/donation_camp_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../application/camp_detail_controller.dart';

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

class CampDetailScreen extends ConsumerWidget {
  const CampDetailScreen({super.key, required this.campId});

  final String campId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final campAsync = ref.watch(campDetailProvider(campId));

    return Scaffold(
      appBar: AppBar(title: const Text('Camp details')),
      body: SafeArea(
        child: campAsync.when(
          data: (camp) {
            if (camp == null) {
              return Center(
                child: Text(
                  'Camp not found',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            return _CampDetailBody(campId: campId, camp: camp);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Failed to load camp: $error',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _CampDetailBody extends ConsumerWidget {
  const _CampDetailBody({required this.campId, required this.camp});

  final String campId;
  final DonationCampModel camp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final rsvpCountAsync = ref.watch(campRsvpCountProvider(campId));
    final rsvpStatusAsync = ref.watch(campRsvpStatusProvider(campId));
    final rsvpControllerState = ref.watch(campRsvpControllerProvider);
    final isRsvped = rsvpStatusAsync.value ?? false;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(camp.name, style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Hosted by ${camp.hostName}', style: textTheme.bodyLarge),
        const SizedBox(height: 4),
        Text(
          _formatDate(camp.date),
          style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 20),
        Text('About this camp', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(camp.description, style: textTheme.bodyMedium),
        const SizedBox(height: 24),
        rsvpCountAsync.when(
          data: (rsvpCount) => Text(
            '$rsvpCount ${rsvpCount == 1 ? 'person has' : 'people have'} '
            "RSVP'd",
            style: textTheme.bodyMedium,
          ),
          loading: () => Text(
            'Loading RSVP count…',
            style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
          error: (error, _) => Text(
            'Failed to load RSVP count',
            style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: isRsvped ? 'Cancel RSVP' : 'RSVP',
          variant: isRsvped
              ? AppButtonVariant.outline
              : AppButtonVariant.filled,
          isLoading: rsvpControllerState.isLoading,
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final succeeded = await ref
                .read(campRsvpControllerProvider.notifier)
                .toggle(campId: campId, isRsvped: isRsvped);
            if (!succeeded) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    isRsvped ? 'Failed to cancel RSVP' : 'Failed to RSVP',
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
