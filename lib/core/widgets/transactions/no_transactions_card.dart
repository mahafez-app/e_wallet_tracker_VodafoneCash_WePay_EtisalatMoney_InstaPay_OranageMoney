import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import 'package:wallet_tracker/core/theme/app_responsive.dart';
import 'package:wallet_tracker/core/theme/app_spacing.dart';

class NoTransactionsCard extends StatelessWidget {
  const NoTransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppResponsive.verticalPadding(40),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64.responsiveRadius,
            color: theme.colorScheme.outline.withAlpha(100),
          ),
          AppSpacing.lg.verticalSpace,
          Text(
            context.l10n.noTransactionsTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
