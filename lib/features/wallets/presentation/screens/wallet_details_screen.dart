import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_tracker/core/widgets/wallets/wallet_provider_info.dart';

import '../../../../core/widgets/app_error_view.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/date_extensions.dart';
import '../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/balance_card.dart';
import '../../../../core/widgets/transactions/no_transactions_card.dart';
import '../../../../core/widgets/transactions/transaction_card.dart';
import '../../../../generated/l10n.dart';
import '../../../transactions/presentation/models/transactions_context.dart';
import '../../../transactions/presentation/widgets/details/transaction_details_bottom_sheet.dart';
import '../../domain/entities/wallet_details_entity.dart';
import '../providers/wallet_details_controller.dart';

class WalletDetailsScreen extends StatelessWidget {
  const WalletDetailsScreen({super.key, required this.walletId});

  final String walletId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).walletDetails),
        centerTitle: true,
      ),
      body: SafeArea(child: _WalletDetailsBody(walletId: walletId)),
    );
  }
}

class _WalletDetailsBody extends ConsumerWidget {
  const _WalletDetailsBody({required this.walletId});

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletDetailsControllerProvider(walletId));

    return state.when(
      loading: () => const AppLoader(),
      error: (error, _) => AppErrorView(error: error),
      data: (details) => SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          children: [
            _BalanceSection(details: details),
            AppSpacing.md.verticalSpace,
            _WalletInfoSection(details: details),
            AppSpacing.md.verticalSpace,
            _RecentTransactionsSection(details: details),
          ],
        ),
      ),
    );
  }
}

class _BalanceSection extends StatelessWidget {
  const _BalanceSection({required this.details});

  final WalletDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final wallet = details.wallet;
    final localizedLastUpdate = wallet.lastBalanceAt.toFormattedDate(context);
    return BalanceCard(
      balance: wallet.currentBalance,
      sentAmount: wallet.totalSent,
      receivedAmount: wallet.totalReceived,
      label: s.currentBalance,
      subtitle: Text(
        '${s.lastActivity}: $localizedLastUpdate',
        style: theme.textTheme.labelMedium?.copyWith(
          color: context.appColors.statsOnGradient.withAlpha(204),
        ),
      ),
    );
  }
}

class _WalletInfoSection extends StatelessWidget {
  const _WalletInfoSection({required this.details});

  final WalletDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final wallet = details.wallet;
    final colors = context.appColors;

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadiusDirectional.circular(20.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
      ),
      child: WalletProviderInfo(
        provider: wallet.provider,
        phoneNumber: wallet.phoneNumber,
        borderRadius: 8,
      ),
    );
  }
}

class _RecentTransactionsSection extends StatelessWidget {
  const _RecentTransactionsSection({required this.details});

  final WalletDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              s.recentTransactions,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {
                final contextData = WalletTransactionsContext(
                  walletId: details.wallet.id,
                  walletLabel:
                      '${details.wallet.provider.displayName(context)} · ${details.wallet.phoneNumber}',
                );
                context.push(AppRoutes.transactionsPath(), extra: contextData);
              },
              child: Text(
                s.viewAll,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.md.verticalSpace,
        if (details.recentTransactions.isEmpty)
          const NoTransactionsCard()
        else
          ...details.recentTransactions.map(
            (tx) => GestureDetector(
              onTap: () => TransactionDetailsBottomSheet.show(context, tx),
              child: TransactionCard(transaction: tx, showProviderInfo: false),
            ),
          ),
      ],
    );
  }
}
