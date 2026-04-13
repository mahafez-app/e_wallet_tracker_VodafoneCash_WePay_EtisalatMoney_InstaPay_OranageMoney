// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';

class SettingsCompactTile extends StatelessWidget {
  const SettingsCompactTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingLabel,
    this.trailingLabelColor,
    this.onTap,
    this.isDanger = false,
    this.isLoading = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final String? trailingLabel;
  final Color? trailingLabelColor;
  final VoidCallback? onTap;
  final bool isDanger;
  final bool isLoading;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Padding(
        padding: AppResponsive.symmetricPadding(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            _SettingsCompactIconChip(icon: icon, isDanger: isDanger),
            AppSpacing.md.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDanger ? colorScheme.error : colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (_hasTrailingContent) ...[
              AppSpacing.md.horizontalSpace,
              _TrailingSection(
                trailingLabel: trailingLabel,
                trailingLabelColor: trailingLabelColor,
                isLoading: isLoading,
                showChevron: showChevron && onTap != null,
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool get _hasTrailingContent =>
      trailingLabel != null || isLoading || (showChevron && onTap != null);
}

class _TrailingSection extends StatelessWidget {
  const _TrailingSection({
    super.key,
    required this.trailingLabel,
    required this.trailingLabelColor,
    required this.isLoading,
    required this.showChevron,
  });

  final String? trailingLabel;
  final Color? trailingLabelColor;
  final bool isLoading;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 160.responsiveWidth),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingLabel != null)
            Flexible(
              child: Text(
                trailingLabel!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: trailingLabelColor ?? colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (isLoading) ...[
            if (trailingLabel != null) AppSpacing.sm.horizontalSpace,
            SizedBox.square(
              dimension: 18.responsiveWidth,
              child: CircularProgressIndicator(strokeWidth: 2.responsiveWidth),
            ),
          ] else if (showChevron) ...[
            if (trailingLabel != null) AppSpacing.xs.horizontalSpace,
            Icon(Icons.chevron_right_rounded, color: colorScheme.outline),
          ],
        ],
      ),
    );
  }
}

class _SettingsCompactIconChip extends StatelessWidget {
  const _SettingsCompactIconChip({
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
        size: 18.responsiveRadius,
      ),
    );
  }
}
