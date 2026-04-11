import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../error/failures.dart';
import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions/failure_extension.dart';
import 'app_button.dart';

/// Standard error view for all AsyncError states.
/// Renders a localized message from [Failure] subtypes, falling back to
/// [S.of(context).errorUnknown] for untyped errors.
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = error is Failure
        ? (error as Failure).toLocalizedString(context)
        : S.of(context).errorUnknown;

    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.responsiveRadius,
              color: theme.colorScheme.error,
            ),
            AppSpacing.md.verticalSpace,
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              AppSpacing.lg.verticalSpace,
              AppButton(label: 'Retry', onPressed: onRetry!),
            ],
          ],
        ),
      ),
    );
  }
}