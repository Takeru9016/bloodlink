import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/donor_profile_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../application/verify_donors_controller.dart';

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

class VerifyDonorsScreen extends ConsumerWidget {
  const VerifyDonorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final pendingAsync = ref.watch(pendingDonorsProvider);

    ref.listen(verifyDonorsControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Action failed: $error')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Verify donors')),
      body: SafeArea(
        child: pendingAsync.when(
          data: (pending) {
            if (pending.isEmpty) {
              return Center(
                child: Text(
                  'No donors awaiting verification',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: pending.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final record = pending[index];
                return _PendingDonorCard(
                  uid: record.id,
                  profile: record.profile,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load queue: $error')),
        ),
      ),
    );
  }
}

class _PendingDonorCard extends ConsumerWidget {
  const _PendingDonorCard({required this.uid, required this.profile});

  final String uid;
  final DonorProfileModel profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final userAsync = ref.watch(donorUserProvider(uid));
    final controllerState = ref.watch(verifyDonorsControllerProvider);
    final isBusy = controllerState.isLoading;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  userAsync.when(
                    data: (user) => user?.name ?? uid,
                    loading: () => uid,
                    error: (_, _) => uid,
                  ),
                  style: textTheme.bodyLarge,
                ),
              ),
              Text(
                _bloodGroupLabels[profile.bloodGroup] ?? '',
                style: textTheme.bodyLarge,
              ),
            ],
          ),
          if (profile.verificationDocUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Image.network(
                profile.verificationDocUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Reject',
                  variant: AppButtonVariant.outline,
                  isLoading: isBusy,
                  onPressed: () => ref
                      .read(verifyDonorsControllerProvider.notifier)
                      .reject(uid),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Approve',
                  isLoading: isBusy,
                  onPressed: () => ref
                      .read(verifyDonorsControllerProvider.notifier)
                      .approve(uid),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
