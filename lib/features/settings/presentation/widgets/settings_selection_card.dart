// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import 'settings_card.dart';

class SettingsSelectionCard extends StatelessWidget {
  const SettingsSelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.valueLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String valueLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SettingsCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        child: Padding(
          padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
          child: Row(
            children: [
              _SelectionIconChip(icon: icon),
              MahafezSpacing.md.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    MahafezSpacing.xs.verticalSpace,
                    Text(
                      valueLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              MahafezSpacing.sm.horizontalSpace,
              Icon(Icons.chevron_right_rounded, color: colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionIconChip extends StatelessWidget {
  const _SelectionIconChip({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.responsiveRadius),
      ),
      child: Icon(icon, color: colorScheme.primary, size: 22.responsiveRadius),
    );
  }
}
