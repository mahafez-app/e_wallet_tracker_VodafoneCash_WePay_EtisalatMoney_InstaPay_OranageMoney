// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import 'settings_card.dart';

class SettingsAppVersionCard extends StatelessWidget {
  const SettingsAppVersionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SettingsCard(
      child: Padding(
        padding: AppResponsive.allPadding(AppSpacing.lg),
        child: Row(
          children: [
            const _VersionIcon(),
            AppSpacing.md.horizontalSpace,
            Expanded(
              child: Text(
                context.l10n.userSettingsAppVersionLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: AppResponsive.symmetricPadding(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(999.responsiveRadius),
              ),
              child: Text(
                AppConstants.appVersion,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionIcon extends StatelessWidget {
  const _VersionIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppResponsive.allPadding(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.responsiveRadius),
      ),
      child: Icon(
        Icons.info_outline_rounded,
        color: Theme.of(context).colorScheme.primary,
        size: 22.responsiveRadius,
      ),
    );
  }
}
