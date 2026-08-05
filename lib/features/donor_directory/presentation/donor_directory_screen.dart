import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/donor_profile_model.dart';
import '../../../data/models/report_model.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/report_button.dart';
import '../application/donor_directory_controller.dart';

const _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
const _radiusOptionsKm = [5.0, 10.0, 25.0, 50.0];

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

class DonorDirectoryScreen extends ConsumerStatefulWidget {
  const DonorDirectoryScreen({super.key});

  @override
  ConsumerState<DonorDirectoryScreen> createState() =>
      _DonorDirectoryScreenState();
}

class _DonorDirectoryScreenState extends ConsumerState<DonorDirectoryScreen> {
  String? _bloodGroup;
  double? _radiusKm;

  String _formatDistance(double? meters) {
    if (meters == null) return 'Distance unavailable';
    if (meters < 1000) return '${meters.round()} m away';
    return '${(meters / 1000).toStringAsFixed(1)} km away';
  }

  String _initial(String name) =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final stateAsync = ref.watch(donorDirectoryControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Donor directory')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterDropdown<String>(
                      label: 'Blood group',
                      value: _bloodGroup,
                      hint: 'Select',
                      items: _bloodGroups
                          .map(
                            (group) => DropdownMenuItem(
                              value: group,
                              child: Text(group),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _bloodGroup = value);
                        ref
                            .read(donorDirectoryControllerProvider.notifier)
                            .setBloodGroup(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FilterDropdown<double?>(
                      label: 'Distance',
                      value: _radiusKm,
                      hint: 'Any distance',
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Any distance'),
                        ),
                        ..._radiusOptionsKm.map(
                          (km) => DropdownMenuItem(
                            value: km,
                            child: Text('Within ${km.round()} km'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _radiusKm = value);
                        ref
                            .read(donorDirectoryControllerProvider.notifier)
                            .setRadiusKm(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (stateAsync.value?.locationStatus ==
                DonorDirectoryLocationStatus.resolving)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text('Finding your location…', style: textTheme.bodyMedium),
                  ],
                ),
              ),
            Expanded(
              child: stateAsync.when(
                data: (state) {
                  if (state.bloodGroup == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Select a blood group to see nearby verified donors.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }
                  if (state.entries.isEmpty) {
                    return Center(
                      child: Text(
                        'No verified donors found for ${state.bloodGroup}',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: state.entries.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final entry = state.entries[index];
                      return AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: colors.brandRed.withValues(
                                    alpha: 0.12,
                                  ),
                                  foregroundColor: colors.brandRed,
                                  child: Text(_initial(entry.name)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.name,
                                        style: textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _formatDistance(entry.distanceMeters),
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                AppBadge(
                                  label:
                                      _bloodGroupLabels[entry
                                          .profile
                                          .bloodGroup] ??
                                      '',
                                  variant: AppBadgeVariant.off,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ReportButton(
                                targetType: ReportTargetType.donor,
                                targetId: entry.id,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load donors: $error',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String label;
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelSmall),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          hint: Text(hint),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
