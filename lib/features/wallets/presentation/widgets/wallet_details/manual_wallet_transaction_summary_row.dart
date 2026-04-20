import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/amount_extension.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../domain/entities/manual_wallet_transaction_assessment.dart';

class ManualWalletTransactionSummaryRow extends StatelessWidget {
  const ManualWalletTransactionSummaryRow({
    super.key,
    required this.assessment,
  });

  final ManualWalletTransactionAssessment assessment;

  @override
  Widget build(BuildContext context) {
    final transaction = assessment.transaction;
    final typeLabel = transaction.type.name == 'receive'
        ? context.l10n.transactionTypeReceive
        : context.l10n.transactionTypeSend;
    final amountText = transaction.amount.toCurrencyText(context);
    final balanceText = transaction.statusBalance?.toCurrencyText(context);

    return Wrap(
      spacing: AppSpacing.sm.responsiveWidth,
      runSpacing: AppSpacing.sm.responsiveHeight,
      children: [
        _SummaryChip(
          label: '$typeLabel • $amountText',
          icon: transaction.type.name == 'receive'
              ? Icons.south_west_rounded
              : Icons.north_east_rounded,
        ),
        _SummaryChip(
          label: transaction.createdAt.toFormattedDate(context),
          icon: Icons.calendar_today_rounded,
        ),
        if (balanceText != null)
          _SummaryChip(
            label: context.l10n.walletManualTransactionBalanceChip(balanceText),
            icon: Icons.account_balance_wallet_rounded,
          ),
        if (assessment.explicitWalletPhone != null)
          _SummaryChip(
            label: context.l10n.walletManualTransactionPhoneChip(
              assessment.explicitWalletPhone!.formattedEgyptianPhoneNumber,
            ),
            icon: Icons.phone_android_rounded,
          ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.symmetricPadding(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(190),
        borderRadius: BorderRadius.circular(16.responsiveRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18.responsiveRadius,
            color: theme.colorScheme.primary,
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
