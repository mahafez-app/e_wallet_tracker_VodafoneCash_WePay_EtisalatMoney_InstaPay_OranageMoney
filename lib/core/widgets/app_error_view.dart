import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions/failure_extension.dart';
import 'app_button.dart';

/// Standard error view for all AsyncError states.
/// Renders a localized message from [Failure] subtypes, falling back to
/// [context.l10n.errorUnknown] for untyped errors.
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = error is Failure
        ? (error as Failure).toLocalizedString(context)
        : context.l10n.errorUnknown;

    return Center(
      child: Padding(
        padding: AppResponsive.allPadding(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: AppResponsive.allPadding(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.error.withAlpha(40),
                    theme.colorScheme.error.withAlpha(10),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.error.withAlpha(50),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64.responsiveRadius,
                color: theme.colorScheme.error,
              ),
            ),
            AppSpacing.xl.verticalSpace,
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              AppSpacing.xxl.verticalSpace,
              AppButton(
                label: context.l10n.startupFallbackRetryAction,
                icon: const Icon(Icons.refresh_rounded),
                onPressed: onRetry!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
