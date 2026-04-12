import 'package:flutter/material.dart';

import '../../theme/app_responsive.dart';
import '../../theme/app_spacing.dart';

class TransactionInfoChip extends StatelessWidget {
  const TransactionInfoChip({
    super.key,
    required this.leading,
    required this.leadingBackgroundColor,
    required this.label,
    required this.value,
  });

  final Widget leading;
  final Color leadingBackgroundColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(10.responsiveRadius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.responsiveWidth,
        vertical: 7.responsiveHeight,
      ),
      child: Row(
        children: [
          Container(
            width: 26.responsiveRadius,
            height: 26.responsiveRadius,
            decoration: BoxDecoration(
              color: leadingBackgroundColor,
              borderRadius: BorderRadius.circular(8.responsiveRadius),
            ),
            child: Center(child: leading),
          ),
          AppSpacing.sm.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(200),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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
