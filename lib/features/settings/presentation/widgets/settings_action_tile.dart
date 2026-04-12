// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';

class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
    this.isLoading = false,
    this.showTrailing = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;
  final bool isLoading;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(24.responsiveRadius),
      child: Padding(
        padding: AppResponsive.allPadding(AppSpacing.lg),
        child: Row(
          children: [
            _ActionIconChip(icon: icon, isDanger: isDanger),
            AppSpacing.md.horizontalSpace,
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDanger ? colorScheme.error : colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (isLoading)
              SizedBox.square(
                dimension: 20.responsiveWidth,
                child: CircularProgressIndicator(
                  strokeWidth: 2.responsiveWidth,
                ),
              )
            else if (showTrailing)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDanger
                    ? colorScheme.error.withAlpha(120)
                    : colorScheme.outline,
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionIconChip extends StatelessWidget {
  const _ActionIconChip({
    super.key,
    required this.icon,
    required this.isDanger,
  });

  final IconData icon;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDanger
            ? colorScheme.errorContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.responsiveRadius),
      ),
      child: Icon(
        icon,
        color: isDanger ? colorScheme.error : colorScheme.primary,
        size: 20.responsiveRadius,
      ),
    );
  }
}
