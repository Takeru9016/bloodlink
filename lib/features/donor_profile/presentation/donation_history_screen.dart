import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/donor_profile_model.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/donor_verification_controller.dart';

const _bloodGroupLabels = {
  BloodGroup.aPositive: 'A+',
  BloodGroup.aNegative: 'A-',
  BloodGroup.bPositive: 'B+',
  BloodGroup.bNegative: 'B-',
  BloodGroup.oPositive: 'O+',
  BloodGroup.oNegative: 'O-',
  BloodGroup.abPositive: 'AB+',
  BloodGroup.abNegative: 'AB-',
};

String _formatDate(DateTime date) {
  const months = [
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
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

class DonationHistoryScreen extends ConsumerWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final profileAsync = ref.watch(myDonorProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Donation history')),
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Set up your donor profile to start tracking your donations.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Set up donor profile',
                        onPressed: () =>
                            context.pushNamed(AppRoute.donorProfileSetupName),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                AppCard(
                  child: Row(
                    children: [
                      AppBadge(
                        label: _bloodGroupLabels[profile.bloodGroup]!,
                        variant: AppBadgeVariant.off,
                      ),
                      const SizedBox(width: 8),
                      AppBadge(
                        label: switch (profile.verificationStatus) {
                          VerificationStatus.verified => 'Verified donor',
                          VerificationStatus.pending => 'Verification pending',
                          VerificationStatus.unverified => 'Not verified',
                        },
                        variant: switch (profile.verificationStatus) {
                          VerificationStatus.verified =>
                            AppBadgeVariant.verified,
                          VerificationStatus.pending => AppBadgeVariant.pending,
                          VerificationStatus.unverified => AppBadgeVariant.off,
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Last donation', style: textTheme.labelSmall),
                      const SizedBox(height: 6),
                      Text(
                        profile.lastDonationDate != null
                            ? _formatDate(
                                profile.lastDonationDate!.toDate().toLocal(),
                              )
                            : 'No donation recorded yet',
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Honest placeholder, same treatment as Profile's stats row
                // (see CLAUDE.md §7): donorProfiles only carries this single
                // nullable lastDonationDate, not a per-donation record, so a
                // real scrollable history list has no data source yet.
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full history not tracked yet',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Only your most recent donation date is stored today — "
                        "there's no record of individual past donations yet.",
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load profile: $error')),
        ),
      ),
    );
  }
}
