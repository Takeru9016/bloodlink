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

    if (onTap == null) {
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: colors.surfaceMuted,
          borderRadius: radius,
        ),
        child: child,
      );
    }

    return Material(
      color: colors.surfaceMuted,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
