import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final radius = BorderRadius.circular(AppRadius.card);
    final shadow = [
      BoxShadow(
        color: colors.textPrimary.withValues(alpha: 0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ];

    if (onTap == null) {
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: radius,
          boxShadow: shadow,
        ),
        child: child,
      );
    }

    return Container(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow),
      child: Material(
        color: colors.surface,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
