import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/donor_profile_model.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/donor_verification_controller.dart';

const _statusCopy = {
  VerificationStatus.unverified:
      "Upload a photo of a government ID so a bank admin can verify you as a donor. "
      "This does not clear you to donate — real eligibility checks happen at the bank.",
  VerificationStatus.pending:
      'Your ID is under review. This usually takes a day or two.',
  VerificationStatus.verified:
      "You're verified. You'll appear in the donor directory for your blood group.",
};

class DonorVerificationScreen extends ConsumerWidget {
  const DonorVerificationScreen({super.key});

  Future<void> _pickSource(BuildContext context, WidgetRef ref) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    await ref
        .read(donorVerificationControllerProvider.notifier)
        .pickAndSubmit(source);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final profileAsync = ref.watch(myDonorProfileProvider);
    final controllerState = ref.watch(donorVerificationControllerProvider);

    ref.listen(donorVerificationControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $error')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Verify your identity')),
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return Center(
                child: Text(
                  'Set up your donor profile first',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            final status = profile.verificationStatus;
            final isVerified = status == VerificationStatus.verified;
            final isPending = status == VerificationStatus.pending;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBadge(
                          label: switch (status) {
                            VerificationStatus.verified => 'Verified',
                            VerificationStatus.pending => 'Pending review',
                            VerificationStatus.unverified => 'Not verified',
                          },
                          variant: switch (status) {
                            VerificationStatus.verified =>
                              AppBadgeVariant.verified,
                            VerificationStatus.pending =>
                              AppBadgeVariant.pending,
                            VerificationStatus.unverified =>
                              AppBadgeVariant.off,
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(_statusCopy[status]!, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  if (profile.verificationDocUrl != null) ...[
                    const SizedBox(height: 20),
                    Text('Submitted ID', style: textTheme.labelSmall),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      child: Image.network(
                        profile.verificationDocUrl!,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (!isVerified)
                    AppButton(
                      label: isPending ? 'Upload a different ID' : 'Upload ID',
                      isLoading: controllerState.isLoading,
                      onPressed: () => _pickSource(context, ref),
                    ),
                ],
              ),
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
