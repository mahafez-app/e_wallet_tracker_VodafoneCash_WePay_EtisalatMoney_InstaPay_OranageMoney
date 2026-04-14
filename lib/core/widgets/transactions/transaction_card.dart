// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/domain/entities/transaction_entity.dart';

import '../../domain/enums/transaction_type.dart';
import '../../theme/app_color_extension.dart';
import '../../theme/app_responsive.dart';
import '../../theme/app_spacing.dart';
import '../../utils/extensions/amount_extension.dart';
import '../../utils/extensions/date_extensions.dart';
import '../../utils/extensions/localization_extension.dart';
import '../../utils/extensions/phone_number_extension.dart';
import '../../utils/extensions/wallet_provider_ext.dart';
import '../wallets/wallet_provider_icon.dart';
import 'transaction_info_chip.dart';

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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = context.appColors;

    final isReceive = transaction.type == TransactionType.receive;
    final typeColor = isReceive ? colors.success : colors.danger;
    final counterparty = transaction.counterpartyNumber;
    final formattedDateTime = transaction.createdAt.toTransactionDateTimeLabel(
      context,
    );

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
                          ? l10n.transactionTypeReceive
                          : l10n.transactionTypeSend,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15.responsiveFont,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Spacer(),
                    Text(
                      transaction.amount.toCurrencyText(
                        context,
                        sign: isReceive ? '+' : '-',
                      ),
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
                      formattedDateTime,
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
                  TransactionInfoChip(
                    leading: WalletProviderIcon(
                      provider: transaction.provider,
                      size: AppSpacing.xl.responsiveRadius,
                    ),
                    leadingBackgroundColor: theme.colorScheme.surface,
                    label: l10n.walletLabel,
                    value:
                        '${transaction.provider.displayName(context)} · ${transaction.phoneNumber.formattedEgyptianPhoneNumber}',
                  ),
                ],
                if (counterparty != null) ...[
                  AppSpacing.xs.verticalSpace,
                  TransactionInfoChip(
                    leading: Icon(
                      Icons.person_outline_rounded,
                      size: 13.responsiveRadius,
                      color: typeColor,
                    ),
                    leadingBackgroundColor: typeColor.withAlpha(30),
                    label: isReceive
                        ? l10n.transaction_receivedFrom
                        : l10n.transaction_sentTo,
                    value: counterparty,
                  ),
                ],
                if (isReceive) ...[
                  AppSpacing.xs.verticalSpace,
                  TransactionInfoChip(
                    leading: Icon(
                      transaction.isPaid!
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 13.responsiveRadius,
                      color: transaction.isPaid!
                          ? colors.success
                          : theme.colorScheme.onSurfaceVariant.withAlpha(150),
                    ),
                    leadingBackgroundColor: transaction.isPaid!
                        ? colors.success.withAlpha(30)
                        : theme.colorScheme.onSurface.withAlpha(18),
                    label: l10n.paymentStatus,
                    value: transaction.isPaid!
                        ? l10n.transactionStatusPaid
                        : l10n.transactionStatusUnpaid,
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
