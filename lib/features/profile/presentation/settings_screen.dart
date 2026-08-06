import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_input.dart';
import '../application/settings_controller.dart';

const _radiusOptionsKm = [0.0, 5.0, 10.0, 15.0, 25.0, 50.0];

String _radiusLabel(double km) => km == 0 ? 'Off' : '${km.toInt()} km';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final settingsAsync = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: settingsAsync.when(
          data: (state) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Account', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              _AccountInfoSection(user: state.profile.user),
              const SizedBox(height: 24),
              Text('Notifications', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              _PushPermissionTile(enabled: state.pushEnabled),
              if (state.profile.isDonor) ...[
                const SizedBox(height: 12),
                _NearbyAlertsSection(
                  hasDonorProfile: state.profile.donorProfile != null,
                  currentRadiusKm: state.profile.donorProfile?.optInRadiusKm,
                ),
              ],
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Failed to load settings: $error',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountInfoSection extends ConsumerStatefulWidget {
  const _AccountInfoSection({required this.user});

  final UserModel user;

  @override
  ConsumerState<_AccountInfoSection> createState() =>
      _AccountInfoSectionState();
}

class _AccountInfoSectionState extends ConsumerState<_AccountInfoSection> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.user.name);
  late final _phoneController = TextEditingController(
    text: widget.user.phone ?? '',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final phone = _phoneController.text.trim();
    await ref
        .read(settingsControllerProvider.notifier)
        .saveAccountInfo(
          name: _nameController.text.trim(),
          phone: phone.isEmpty ? null : phone,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account info updated')));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isSaving = ref.watch(settingsControllerProvider).isLoading;

    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInput(
              label: 'Full name',
              controller: _nameController,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Name is required'
                  : null,
            ),
            const SizedBox(height: 12),
            AppInput(
              label: 'Phone (optional)',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            Text('Email', style: textTheme.labelSmall),
            const SizedBox(height: 6),
            Text(
              widget.user.email,
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              "Email can't be changed here yet.",
              style: textTheme.labelSmall?.copyWith(
                color: colors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            AppButton(label: 'Save', isLoading: isSaving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class _PushPermissionTile extends ConsumerWidget {
  const _PushPermissionTile({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isLoading = ref.watch(settingsControllerProvider).isLoading;

    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Push notifications', style: textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text(
                  enabled ? 'Enabled' : 'Not enabled',
                  style: textTheme.labelSmall?.copyWith(
                    color: enabled ? colors.brandRed : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (!enabled)
            IntrinsicWidth(
              child: AppButton(
                label: 'Enable',
                variant: AppButtonVariant.outline,
                isLoading: isLoading,
                onPressed: () => ref
                    .read(settingsControllerProvider.notifier)
                    .requestPushPermission(),
              ),
            ),
        ],
      ),
    );
  }
}

class _NearbyAlertsSection extends ConsumerWidget {
  const _NearbyAlertsSection({
    required this.hasDonorProfile,
    required this.currentRadiusKm,
  });

  final bool hasDonorProfile;
  final double? currentRadiusKm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    if (!hasDonorProfile) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nearby request alerts', style: textTheme.bodyLarge),
            const SizedBox(height: 6),
            Text(
              'Finish setting up your donor profile to get notified about '
              'nearby blood requests.',
              style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Set up donor profile',
              variant: AppButtonVariant.outline,
              onPressed: () =>
                  context.pushNamed(AppRoute.donorProfileSetupName),
            ),
          ],
        ),
      );
    }

    final isLoading = ref.watch(settingsControllerProvider).isLoading;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nearby request alerts', style: textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text(
            'How far away a blood request can be for us to notify you. '
            "Choose Off to stop these alerts entirely.",
            style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final km in _radiusOptionsKm)
                ChoiceChip(
                  label: Text(_radiusLabel(km)),
                  selected: currentRadiusKm == km,
                  onSelected: isLoading
                      ? null
                      : (selected) {
                          if (!selected) return;
                          ref
                              .read(settingsControllerProvider.notifier)
                              .updateOptInRadius(km);
                        },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
