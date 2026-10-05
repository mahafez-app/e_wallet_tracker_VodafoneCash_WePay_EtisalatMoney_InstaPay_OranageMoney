import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/transactions/no_transactions_card.dart';
import '../../../../../core/widgets/transactions/transaction_card.dart';
import '../../../../transactions/presentation/navigation/transactions_route_data.dart';
import '../../../../transactions/presentation/widgets/details/transaction_details_bottom_sheet.dart';
import '../../../domain/entities/wallet_details_entity.dart';

class WalletRecentTransactionsSection extends StatelessWidget {
  const WalletRecentTransactionsSection({super.key, required this.details});

  final WalletDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final hasTransactions = details.recentTransactions.isNotEmpty;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentTransactions,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (hasTransactions)
              TextButton(
                onPressed: () {
                  final contextData = WalletTransactionsRouteData(
                    walletId: details.wallet.id,
                    provider: details.wallet.provider,
                    phoneNumber: details.wallet.phoneNumber,
                  );
                  context.push(
                    AppRoutes.transactionsPath(),
                    extra: contextData,
                  );
                },
                child: Text(
                  l10n.viewAll,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        MahafezSpacing.md.verticalSpace,
        if (!hasTransactions)
          NoTransactionsCard(
            title: l10n.transactions_emptyTitle,
            description: l10n.transactions_emptyWalletDescription,
          )
        else
          ...details.recentTransactions.map(
            (transaction) => GestureDetector(
              onTap: () =>
                  TransactionDetailsBottomSheet.show(context, transaction),
              child: TransactionCard(
                transaction: transaction,
                showProviderInfo: false,
              ),
            ),
          ),
      ],
    );
  }
}
