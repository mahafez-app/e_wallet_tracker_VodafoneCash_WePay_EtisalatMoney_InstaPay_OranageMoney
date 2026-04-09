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
      insetPadding: EdgeInsets.all(AppSpacing.xl.responsiveRadius),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.xl.responsiveRadius),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28.responsiveRadius),
          boxShadow: [
            BoxShadow(
              color: colors.cardShadow,
              blurRadius: 24.responsiveRadius,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.lg.responsiveRadius),
              decoration: BoxDecoration(
                color: backgroundColor.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: foregroundColor,
                size: 48.responsiveRadius,
              ),
            ),
            AppSpacing.xl.verticalSpace,
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.md.verticalSpace,
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.xxl.verticalSpace,
            Row(
              children: [
                if (cancelLabel != null)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(end: AppSpacing.sm.responsiveWidth),
                      child: OutlinedButton(
                        onPressed: onCancel ?? () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.responsiveHeight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.responsiveRadius),
                          ),
                        ),
                        child: Text(cancelLabel!),
                      ),
                    ),
                  ),
                if (confirmLabel != null)
                  Expanded(
                    child: AppButton(
                      label: confirmLabel!,
                      onPressed: onConfirm ?? () => Navigator.pop(context),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
