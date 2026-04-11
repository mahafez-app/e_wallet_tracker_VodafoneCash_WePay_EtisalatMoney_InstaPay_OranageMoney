import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/domain/enums/transaction_type.dart';
import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/amount_extension.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';

/// Centered header: large icon, amount, and transaction type label.
class TransactionHeaderSection extends StatelessWidget {
  const TransactionHeaderSection({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final l10n = context.l10n;
    final isReceive = transaction.type == TransactionType.receive;
    final typeColor = isReceive ? colors.success : colors.danger;
    final sign = isReceive ? '+' : '-';
    final label = isReceive
        ? l10n.transaction_typeReceiveLabel
        : l10n.transaction_typeSendLabel;
    final amountText = '$sign${transaction.amount.toLocalizedAmount(context)}';

    return Column(
      children: [
        Container(
          width: 72.responsiveRadius,
          height: 72.responsiveRadius,
          decoration: BoxDecoration(
            color: typeColor.withAlpha(30),
            borderRadius: BorderRadius.circular(22.responsiveRadius),
          ),
          child: Icon(
            isReceive
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            color: typeColor,
            size: 32.responsiveRadius,
          ),
        ),
        AppSpacing.lg.verticalSpace,
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$amountText ',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: typeColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              TextSpan(
                text: l10n.currency,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: typeColor.withAlpha(200),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.xs.verticalSpace,
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
