import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';

class SmsPermissionFeatureItem extends StatelessWidget {
  const SmsPermissionFeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(16.responsiveRadius),
      ),
      child: Row(
        children: [
          Container(
            padding: AppResponsive.allPadding(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12.responsiveRadius),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                4.responsiveHeight.verticalSpace,
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
