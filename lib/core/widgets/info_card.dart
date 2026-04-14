import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/theme/app_responsive.dart';
import 'package:wallet_tracker/core/theme/app_spacing.dart';

class InfoCard extends StatelessWidget {
  final String text;
  final bool isDanger;

  const InfoCard({super.key, required this.text, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDanger
            ? theme.colorScheme.errorContainer.withAlpha(80)
            : theme.colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(20.responsiveRadius),
        border: BorderDirectional(
          start: BorderSide(
            color: isDanger
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
            width: 5.responsiveWidth,
          ),
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
