import 'package:flutter/material.dart';

enum AppButtonType { primary, secondary, tertiary }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.foregroundColor,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final Widget? icon;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    final Color indicatorColor = switch (type) {
      AppButtonType.primary =>
        backgroundColor != null
            ? theme.colorScheme.onSurface
            : theme.colorScheme.onPrimary,
      AppButtonType.secondary ||
      AppButtonType.tertiary => foregroundColor ?? theme.colorScheme.primary,
    };

    final Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            ),
          )
        : Text(label);

    final ButtonStyle? customStyle =
        foregroundColor != null || backgroundColor != null
        ? switch (type) {
            AppButtonType.primary => FilledButton.styleFrom(
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
            ),
            AppButtonType.secondary => OutlinedButton.styleFrom(
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
            ),
            AppButtonType.tertiary => TextButton.styleFrom(
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
            ),
          }
        : null;

    if (icon != null && !isLoading) {
      return switch (type) {
        AppButtonType.primary => FilledButton.icon(
          onPressed: isDisabled ? null : onPressed,
          style: customStyle,
          icon: icon!,
          label: child,
        ),
        AppButtonType.secondary => OutlinedButton.icon(
          onPressed: isDisabled ? null : onPressed,
          style: customStyle,
          icon: icon!,
          label: child,
        ),
        AppButtonType.tertiary => TextButton.icon(
          onPressed: isDisabled ? null : onPressed,
          style: customStyle,
          icon: icon!,
          label: child,
        ),
      };
    }

    return switch (type) {
      AppButtonType.primary => FilledButton(
        onPressed: isDisabled ? null : onPressed,
        style: customStyle,
        child: child,
      ),
      AppButtonType.secondary => OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: customStyle,
        child: child,
      ),
      AppButtonType.tertiary => TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: customStyle,
        child: child,
      ),
    };
  }
}
