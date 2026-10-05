// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

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
        padding: MahafezResponsive.symmetricPadding(
          horizontal: MahafezSpacing.lg,
          vertical: MahafezSpacing.md,
        ),
        child: Row(
          children: [
            _SettingsCompactIconChip(icon: icon, isDanger: isDanger),
            MahafezSpacing.md.horizontalSpace,
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
              MahafezSpacing.md.horizontalSpace,
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
            if (trailingLabel != null) MahafezSpacing.sm.horizontalSpace,
            SizedBox.square(
              dimension: 18.responsiveWidth,
              child: CircularProgressIndicator(strokeWidth: 2.responsiveWidth),
            ),
          ] else if (showChevron) ...[
            if (trailingLabel != null) MahafezSpacing.xs.horizontalSpace,
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
      padding: MahafezResponsive.allPadding(MahafezSpacing.sm),
      decoration: BoxDecoration(
        color: isDanger
            ? colorScheme.errorContainer.withAlpha(80)
            : colorScheme.primary.withAlpha(25),
        borderRadius: BorderRadius.circular(16.responsiveRadius),
        border: Border.all(
          color: isDanger 
            ? colorScheme.error.withAlpha(50) 
            : colorScheme.primary.withAlpha(50),
          width: 0.5,
        ),
      ),
      child: Icon(
        icon,
        color: isDanger ? colorScheme.error : colorScheme.primary,
        size: 20.responsiveRadius,
      ),
    );
  }
}
