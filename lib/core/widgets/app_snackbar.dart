import 'package:flutter/material.dart';

import '../theme/app_color_extension.dart';
import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';

enum AppSnackbarType { success, error, info, warning }

class AppSnackbar {
  const AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    final (backgroundColor, foregroundColor, icon) = switch (type) {
      AppSnackbarType.success => (
        colors.successContainer,
        colors.success,
        Icons.check_circle_rounded,
      ),
      AppSnackbarType.error => (
        colors.dangerContainer,
        colors.danger,
        Icons.error_rounded,
      ),
      AppSnackbarType.warning => (
        colors.warningContainer,
        colors.warning,
        Icons.warning_rounded,
      ),
      AppSnackbarType.info => (
        colors.infoContainer,
        colors.info,
        Icons.info_rounded,
      ),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: AppResponsive.symmetricPadding(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.responsiveRadius),
            border: Border.all(color: backgroundColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: colors.cardShadow,
                blurRadius: 12.responsiveRadius,
                offset: Offset(0, 4.responsiveHeight),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: AppResponsive.allPadding(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: backgroundColor.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: foregroundColor,
                  size: 20.responsiveRadius,
                ),
              ),
              AppSpacing.md.horizontalSpace,
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
