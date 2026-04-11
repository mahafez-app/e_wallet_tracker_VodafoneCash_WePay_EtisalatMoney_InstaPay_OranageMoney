import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/transactions/transaction_card.dart';
import '../../../../generated/l10n.dart';
import '../../../wallets/presentation/providers/wallet_details_controller.dart';
import '../providers/transactions_controller.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, this.walletId});

  final String? walletId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _TransactionsTitle(walletId: walletId),
      ),
      body: SafeArea(child: _TransactionsBody(walletId: walletId)),
    );
  }
}

class _TransactionsTitle extends ConsumerWidget {
  const _TransactionsTitle({required this.walletId});

  final String? walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    if (walletId == null) return Text(s.allTransactions);

    final title = ref
        .watch(walletDetailsControllerProvider(walletId!))
        .maybeWhen(
          data: (_) => s.walletTransactions,
          orElse: () => s.transactionsHistory,
        );

    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _TransactionsBody extends ConsumerWidget {
  const _TransactionsBody({required this.walletId});

  final String? walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(walletId));

    return switch (state) {
      AsyncLoading() => const AppLoader(),
      AsyncError(:final error) => AppErrorView(error: error),
      AsyncData(:final value) => value.isEmpty
          ? const _EmptyTransactionsView()
          : _TransactionsList(transactions: value),
    };
  }
}

class _TransactionsList extends StatelessWidget {
  const _TransactionsList({required this.transactions});

  final List transactions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppSpacing.pagePadding,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return TransactionCard(transaction: transactions[index]);
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
            size: 64.responsiveRadius,
            color: theme.colorScheme.outline.withAlpha(76),
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
