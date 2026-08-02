import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/donor_profile_model.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/application/auth_controller.dart';
import '../application/profile_controller.dart';

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

String _initialsFor(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  final first = parts.first[0];
  final last = parts.length > 1 ? parts.last[0] : '';
  return (first + last).toUpperCase();
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: profileAsync.when(
          data: (state) => RefreshIndicator(
            onRefresh: () =>
                ref.read(profileControllerProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              children: [
                _ProfileHeader(state: state),
                const SizedBox(height: 24),
                const _StatsRow(),
                const SizedBox(height: 24),
                const _MenuList(),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Failed to load profile: $error',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.state});

  final ProfileState state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final donorProfile = state.donorProfile;

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colors.brandRed,
          child: Text(
            _initialsFor(state.user.name),
            style: textTheme.headlineSmall?.copyWith(color: colors.surface),
          ),
        ),
        const SizedBox(height: 12),
        Text(state.user.name, style: textTheme.titleLarge),
        const SizedBox(height: 8),
        if (donorProfile != null)
          GestureDetector(
            onTap: () => context.pushNamed(AppRoute.donorVerificationName),
            child: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppBadge(
                  label: _bloodGroupLabels[donorProfile.bloodGroup]!,
                  variant: AppBadgeVariant.off,
                ),
                AppBadge(
                  label: switch (donorProfile.verificationStatus) {
                    VerificationStatus.verified => 'Verified donor',
                    VerificationStatus.pending => 'Verification pending',
                    VerificationStatus.unverified => 'Not verified',
                  },
                  variant: switch (donorProfile.verificationStatus) {
                    VerificationStatus.verified => AppBadgeVariant.verified,
                    VerificationStatus.pending => AppBadgeVariant.pending,
                    VerificationStatus.unverified => AppBadgeVariant.off,
                  },
                ),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: colors.textSecondary,
                ),
              ],
            ),
          )
        else if (state.isDonor)
          GestureDetector(
            onTap: () => context.pushNamed(AppRoute.donorProfileSetupName),
            child: Text(
              'Finish setting up your donor profile',
              style: textTheme.bodyMedium?.copyWith(color: colors.brandRed),
            ),
          ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatTile(label: 'Lives saved')),
        SizedBox(width: 12),
        Expanded(child: _StatTile(label: 'Donations')),
        SizedBox(width: 12),
        Expanded(child: _StatTile(label: 'Rating')),
      ],
    );
  }
}

/// All three stats are honest "not tracked yet" placeholders, not `0` — none
/// of them have a real data source yet: there's no donor-to-request
/// attribution anywhere in this bank-mediated-matching app (`fulfilledByDonorId`
/// doesn't exist — see `CLAUDE.md` §7), no donation-record history collection
/// (only a single nullable `lastDonationDate`), and no rating logic at all.
/// A bare `0`/`—` here would be indistinguishable from a real zero value, so
/// this renders distinct muted copy instead, per SPEC's "label it honestly,
/// don't fake data" rule for the Profile stats row.
class _StatTile extends StatelessWidget {
  const _StatTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          Text(
            'Not tracked yet',
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _MenuList extends ConsumerWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;

    // Material (not AppCard) on purpose: AppCard's no-`onTap` variant is a
    // plain colored Container, and nesting ListTiles (which paint ink
    // splashes on the nearest Material ancestor) inside that DecoratedBox
    // hides their ink/background — Flutter asserts on this in debug mode.
    return Material(
      color: colors.surfaceMuted,
      borderRadius: BorderRadius.circular(AppRadius.card),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.history,
            label: 'Donation history',
            onTap: () => context.pushNamed(AppRoute.donationHistoryName),
          ),
          Divider(color: colors.border, height: 1),
          _MenuTile(
            icon: Icons.military_tech_outlined,
            label: 'Badges',
            onTap: () => context.pushNamed(AppRoute.badgesName),
          ),
          Divider(color: colors.border, height: 1),
          _MenuTile(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => context.pushNamed(AppRoute.settingsName),
          ),
          Divider(color: colors.border, height: 1),
          _MenuTile(
            icon: Icons.help_outline,
            label: 'Help & support',
            onTap: () => context.pushNamed(AppRoute.helpSupportName),
          ),
          Divider(color: colors.border, height: 1),
          _MenuTile(
            icon: Icons.logout,
            label: 'Log out',
            iconColor: colors.error,
            labelColor: colors.error,
            // No manual navigation — `_redirect` in app_router.dart reacts to
            // the resulting authStateProvider change, same as AppDrawer.
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(label, style: TextStyle(color: labelColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
