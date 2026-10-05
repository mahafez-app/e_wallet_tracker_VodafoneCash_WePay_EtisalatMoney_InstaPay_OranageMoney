import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final String actionLabel;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        MahafezSpacing.md.horizontalSpace,
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: theme.colorScheme.primary.withAlpha(20),
            foregroundColor: theme.colorScheme.primary,
            padding: MahafezResponsive.symmetricPadding(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.responsiveRadius),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 13.responsiveFont,
                ),
              ),
              MahafezSpacing.xs.horizontalSpace,
              Icon(icon, size: 16.responsiveRadius),
            ],
          ),
        ),
      ],
    );
  }
}
