import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'app_button.dart';

/// Friendly error state for an `AsyncValue.when(error: ...)` branch.
///
/// Deliberately never renders the raw error object — the underlying
/// exception is already reported to Crashlytics once by
/// `AppProviderObserver` regardless of which screen renders this widget.
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: colors.error, size: 32),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              AppButton(
                label: 'Retry',
                variant: AppButtonVariant.outline,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
