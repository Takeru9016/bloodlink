import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

enum AppButtonVariant { filled, outline }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final effectiveOnPressed = isLoading ? null : onPressed;
    final isDisabled = effectiveOnPressed == null && !isLoading;

    final spinnerColor = variant == AppButtonVariant.filled
        ? colors.surface
        : colors.textPrimary;

    final child = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
            ),
          )
        : Text(label);

    final button = variant == AppButtonVariant.filled
        ? ElevatedButton(onPressed: effectiveOnPressed, child: child)
        : OutlinedButton(onPressed: effectiveOnPressed, child: child);

    return Opacity(opacity: isDisabled ? 0.5 : 1, child: button);
  }
}
