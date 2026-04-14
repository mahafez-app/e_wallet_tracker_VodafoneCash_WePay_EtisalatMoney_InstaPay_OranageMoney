import 'package:flutter/material.dart';

import '../theme/app_color_extension.dart';
import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';

enum AppDialogType { success, error, info, warning }

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final AppDialogType type;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.type = AppDialogType.info,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    AppDialogType type = AppDialogType.info,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        type: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    final (backgroundColor, foregroundColor, icon) = switch (type) {
      AppDialogType.success => (
        colors.successContainer,
        colors.success,
        Icons.check_circle_outline_rounded,
      ),
      AppDialogType.error => (
        colors.dangerContainer,
        colors.danger,
        Icons.error_outline_rounded,
      ),
      AppDialogType.warning => (
        colors.warningContainer,
        colors.warning,
        Icons.warning_amber_rounded,
      ),
      AppDialogType.info => (
        colors.infoContainer,
        colors.info,
        Icons.info_outline_rounded,
      ),
    };

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: AppResponsive.allPadding(AppSpacing.xl),
      child: Container(
        padding: AppResponsive.allPadding(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(32.responsiveRadius),
          boxShadow: [
            BoxShadow(
              color: colors.cardShadow.withAlpha(120),
              blurRadius: 30,
              offset: Offset(0, 15.responsiveHeight),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: AppResponsive.allPadding(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [backgroundColor.withAlpha(80), backgroundColor.withAlpha(30)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: backgroundColor.withAlpha(100),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: foregroundColor,
                size: 56.responsiveRadius,
              ),
            ),
            AppSpacing.xl.verticalSpace,
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.md.verticalSpace,
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.xxl.verticalSpace,
            Row(
              children: [
                if (cancelLabel != null)
                  Expanded(
                    child: AppButton(
                      label: cancelLabel!,
                      type: AppButtonType.tertiary,
                      onPressed: onCancel ?? () => Navigator.pop(context),
                    ),
                  ),
                if (confirmLabel != null) ...[
                  if (cancelLabel != null) AppSpacing.md.horizontalSpace,
                  Expanded(
                    child: AppButton(
                      label: confirmLabel!,
                      onPressed: onConfirm ?? () => Navigator.pop(context),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
