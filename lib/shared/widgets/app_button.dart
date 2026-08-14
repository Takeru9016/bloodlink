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
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  /// The global button theme sets `minimumSize: Size.fromHeight(54)` (i.e.
  /// width: infinity) for the full-width buttons used on forms/screens.
  /// Set false for buttons in a bounded-width row (e.g. `AlertDialog.actions`)
  /// — an infinite-width minimum there blows the whole layout up.
  final bool expand;

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

    final compactStyle = expand
        ? null
        : ButtonStyle(
            minimumSize: WidgetStateProperty.all(const Size(64, 44)),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20),
            ),
          );

    final button = variant == AppButtonVariant.filled
        ? ElevatedButton(
            onPressed: effectiveOnPressed,
            style: compactStyle,
            child: child,
          )
        : OutlinedButton(
            onPressed: effectiveOnPressed,
            style: compactStyle,
            child: child,
          );

    return Opacity(opacity: isDisabled ? 0.5 : 1, child: button);
  }
}
