import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/transactions/transaction_card.dart';
import '../../../../generated/l10n.dart';
import '../../../wallets/presentation/providers/wallet_details_controller.dart';
import '../providers/transactions_controller.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key, this.walletId});

  final String? walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final theme = Theme.of(context);

    String title = s.allTransactions;
    if (walletId != null) {
      final walletState = ref.watch(walletDetailsControllerProvider(walletId!));
      title = walletState.when(
        data: (details) => s.walletTransactions,
        loading: () => s.transactionsHistory,
        error: (_, _) => s.transactionsHistory,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(child: _TransactionsBody(walletId: walletId)),
    );
  }
}

class _TransactionsBody extends ConsumerWidget {
  const _TransactionsBody({this.walletId});

  final String? walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(walletId));

    return state.when(
      loading: () => const AppLoader(),
      error: (error, _) => Center(child: Text(error.toString())),
      data: (transactions) {
        if (transactions.isEmpty) {
          return const _EmptyTransactionsView();
        }

        return ListView.builder(
          padding: AppSpacing.pagePadding,
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return TransactionCard(
              transaction: tx,
            );
          },
        );
      },
    );
  }
}

class _EmptyTransactionsView extends StatelessWidget {
  const _EmptyTransactionsView();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: theme.colorScheme.outline.withAlpha(76), // 0.3
          ),
          AppSpacing.lg.verticalSpace,
          Text(
            s.noTransactionsTitle,
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
