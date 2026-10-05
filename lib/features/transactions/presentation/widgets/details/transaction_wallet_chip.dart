import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
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
          size: MahafezSpacing.xl.responsiveRadius,
        ),
        MahafezSpacing.sm.horizontalSpace,
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
