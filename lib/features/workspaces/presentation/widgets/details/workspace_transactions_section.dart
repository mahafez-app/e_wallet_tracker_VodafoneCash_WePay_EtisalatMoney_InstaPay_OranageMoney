// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../../core/widgets/transactions/no_transactions_card.dart';
import '../../../../../core/widgets/transactions/transaction_card.dart';
import '../../../../transactions/presentation/navigation/transactions_route_data.dart';
import '../../../../transactions/presentation/widgets/details/transaction_details_bottom_sheet.dart';
import '../../../domain/entities/workspace_details_entity.dart';

class WorkspaceTransactionsSection extends StatelessWidget {
  const WorkspaceTransactionsSection({super.key, required this.details});

  final WorkspaceDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final hasWallets = details.wallets.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentTransactions,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: hasWallets
                  ? () => context.push(
                      AppRoutes.transactionsPath(),
                      extra: WorkspaceTransactionsRouteData(
                        workspaceId: details.workspace.id,
                        workspaceName: details.workspace.name,
                        wallets: details.wallets
                            .map(
                              (wallet) => WalletFilterOption(
                                walletId: wallet.id,
                                walletLabel:
                                    '${wallet.provider.displayName(context)} · ${wallet.phoneNumber.formattedEgyptianPhoneNumber}',
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : null,
              child: Text(l10n.viewAll),
            ),
          ],
        ),
        AppSpacing.md.verticalSpace,
        if (details.recentTransactions.isEmpty)
          const NoTransactionsCard()
        else
          ...details.recentTransactions.map(
            (transaction) => GestureDetector(
              onTap: () =>
                  TransactionDetailsBottomSheet.show(context, transaction),
              child: TransactionCard(transaction: transaction),
            ),
          ),
      ],
    );
  }
}
