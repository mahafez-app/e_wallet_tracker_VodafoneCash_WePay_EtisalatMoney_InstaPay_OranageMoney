import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../../core/widgets/wallets/wallet_provider_icon.dart';

class TransactionWalletChip extends StatelessWidget {
  const TransactionWalletChip({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        WalletProviderIcon(
          provider: transaction.provider,
          size: AppSpacing.xl.responsiveRadius,
        ),
        AppSpacing.sm.horizontalSpace,
        Expanded(
          child: Text(
            '${transaction.provider.displayName(context)} · ${transaction.phoneNumber.formattedEgyptianPhoneNumber}',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
