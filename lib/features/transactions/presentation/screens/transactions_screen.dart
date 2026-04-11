// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../generated/l10n.dart';
import '../models/transactions_context.dart';
import '../providers/transactions_controller.dart';
import '../widgets/details/transaction_details_bottom_sheet.dart';
import '../widgets/filter_bar/transactions_filter_bar.dart';
import '../widgets/list/transactions_date_grouped_list.dart';
import '../widgets/list/transactions_empty_view.dart';
import '../widgets/list/transactions_load_more_footer.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, required this.transactionsContext});

  final TransactionsContext transactionsContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _TransactionsTitle(context_: transactionsContext),
        centerTitle: true,
      ),
      body: SafeArea(child: _TransactionsBody(context_: transactionsContext)),
    );
  }
}

// ── App bar title ─────────────────────────────────────────────────────────────

class _TransactionsTitle extends StatelessWidget {
  const _TransactionsTitle({super.key, required this.context_});

  final TransactionsContext context_;

  @override
  Widget build(BuildContext context) {
    final label = switch (context_) {
      WalletTransactionsContext(:final walletLabel) =>
        S.of(context).transactions_title_wallet(walletLabel),
      WorkspaceTransactionsContext(:final workspaceName) =>
        S.of(context).transactions_title_workspace(workspaceName),
    };

    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _TransactionsBody extends ConsumerWidget {
  const _TransactionsBody({super.key, required this.context_});

  final TransactionsContext context_;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(transactionsControllerProvider(context_), (previous, next) {
      final nextError = next.error;
      if (nextError == null || previous?.error == nextError) return;
      AppSnackbar.show(
        context,
        message: nextError.toLocalizedString(context),
        type: AppSnackbarType.error,
      );
    });

    return Column(
      children: [
        TransactionsFilterBar(context_: context_),
        Expanded(child: _TransactionsContent(context_: context_)),
      ],
    );
  }
}

// ── Content area ──────────────────────────────────────────────────────────────

class _TransactionsContent extends ConsumerWidget {
  const _TransactionsContent({super.key, required this.context_});

  final TransactionsContext context_;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(context_));

    if (state.isLoadingInitial) return const AppLoader();

    if (state.error != null && state.transactions.isEmpty) {
      return AppErrorView(error: state.error!);
    }

    if (state.transactions.isEmpty) {
      return TransactionsEmptyView(
        context_: context_,
        hasActiveFilter: state.hasActiveFilter,
      );
    }

    final showProviderInfo = context_ is WorkspaceTransactionsContext;

    return TransactionsDateGroupedList(
      groupedTransactions: state.groupedTransactions,
      showProviderInfo: showProviderInfo,
      onTap: (tx) => TransactionDetailsBottomSheet.show(context, tx),
      footer: TransactionsLoadMoreFooter(context_: context_),
    );
  }
}
