import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet_tracker/core/domain/entities/transaction_entity.dart';

import '../../../../generated/l10n.dart';
import '../../domain/enums/transaction_type.dart';
import '../../theme/app_color_extension.dart';
import '../../theme/app_responsive.dart';
import '../../theme/app_spacing.dart';
import '../../utils/extensions/wallet_provider_ext.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
    this.showProviderInfo = true,
  });

  final TransactionEntity transaction;
  final bool showProviderInfo;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context).languageCode;

    final isReceive = transaction.type == TransactionType.receive;
    final typeColor = isReceive ? colors.success : colors.danger;
    final counterparty = transaction.counterpartyNumber;

    final formattedDate = DateFormat.yMMMMd(
      locale,
    ).format(transaction.createdAt);
    final formattedTime = DateFormat.jm(locale).format(transaction.createdAt);

    return Container(
      margin: AppResponsive.onlyPadding(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20.responsiveRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(40),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: AppResponsive.allPadding(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.responsiveRadius,
            height: 46.responsiveRadius,
            decoration: BoxDecoration(
              color: typeColor.withAlpha(30),
              borderRadius: BorderRadius.circular(14.responsiveRadius),
            ),
            child: Icon(
              isReceive
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: typeColor,
              size: 20.responsiveRadius,
            ),
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isReceive
                          ? s.transactionTypeReceive
                          : s.transactionTypeSend,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15.responsiveFont,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${isReceive ? '+' : '-'} ${transaction.amount.toStringAsFixed(2)} ${s.currency}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 17.responsiveFont,
                        fontWeight: FontWeight.w500,
                        color: typeColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                AppSpacing.xs.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12.responsiveRadius,
                      color: theme.colorScheme.onSurfaceVariant.withAlpha(200),
                    ),
                    AppSpacing.sm.horizontalSpace,
                    Text(
                      '$formattedDate · $formattedTime',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(
                          200,
                        ),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
                if (showProviderInfo) ...[
                  AppSpacing.md.verticalSpace,
                  _InfoChip(
                    icon: Icons.account_balance_wallet,
                    iconColor: theme.colorScheme.onPrimaryContainer,
                    iconBg: theme.colorScheme.onSurface.withAlpha(18),
                    label: s.walletLabel,
                    value:
                        '${transaction.provider.displayName(context)} · ${transaction.phoneNumber}',
                  ),
                  if (counterparty != null) ...[
                    AppSpacing.xs.verticalSpace,
                    _InfoChip(
                      icon: Icons.person_outline_rounded,
                      iconColor: typeColor,
                      iconBg: typeColor.withAlpha(30),
                      label: isReceive ? s.fromLabel : s.toLabel,
                      value: counterparty,
                    ),
                  ],
                ],
                if (isReceive) ...[
                  AppSpacing.xs.verticalSpace,
                  _InfoChip(
                    icon: transaction.isPaid!
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    iconColor: transaction.isPaid!
                        ? colors.success
                        : theme.colorScheme.onSurfaceVariant.withAlpha(150),
                    iconBg: transaction.isPaid!
                        ? colors.success.withAlpha(30)
                        : theme.colorScheme.onSurface.withAlpha(18),
                    label: s.paymentStatus,
                    value: transaction.isPaid!
                        ? s.transactionStatusPaid
                        : s.transactionStatusUnpaid,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
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
              color: iconBg,
              borderRadius: BorderRadius.circular(8.responsiveRadius),
            ),
            child: Icon(icon, size: 13.responsiveRadius, color: iconColor),
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
