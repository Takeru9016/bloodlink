import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

enum AppBadgeVariant { verified, pending, off }

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label, required this.variant});

  final String label;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final (Color foreground, Color background) = switch (variant) {
      AppBadgeVariant.verified => (
        colors.success,
        colors.success.withValues(alpha: 0.12),
      ),
      AppBadgeVariant.pending => (
        colors.amber,
        colors.amber.withValues(alpha: 0.12),
      ),
      AppBadgeVariant.off => (colors.textSecondary, colors.surfaceMuted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
