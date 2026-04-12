// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_tracker/core/theme/app_responsive.dart';
import 'package:wallet_tracker/core/theme/app_spacing.dart';

import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../navigation/transactions_route_data.dart';
import '../providers/transactions_controller.dart';
import '../widgets/details/transaction_details_bottom_sheet.dart';
import '../widgets/filter_bar/transactions_filter_bar.dart';
import '../widgets/list/transactions_date_grouped_list.dart';
import '../widgets/list/transactions_empty_view.dart';
import '../widgets/list/transactions_load_more_footer.dart';
import '../widgets/list/transactions_loading_view.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, required this.transactionsContext});

  final TransactionsRouteData transactionsContext;

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

  final TransactionsRouteData context_;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = switch (context_) {
      WalletTransactionsRouteData(:final walletLabel) =>
        l10n.transactions_title_wallet(walletLabel),
      WorkspaceTransactionsRouteData(:final workspaceName) =>
        l10n.transactions_title_workspace(workspaceName),
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

  final TransactionsRouteData context_;

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
        TransactionsFilterBar(routeData: context_),
        AppSpacing.sm.verticalSpace,
        Expanded(child: _TransactionsContent(context_: context_)),
      ],
    );
  }
}

// ── Content area ──────────────────────────────────────────────────────────────

class _TransactionsContent extends ConsumerWidget {
  const _TransactionsContent({super.key, required this.context_});

  final TransactionsRouteData context_;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(context_));

    if (state.isLoadingInitial) {
      return const TransactionsLoadingView();
    }

    if (state.error != null && state.transactions.isEmpty) {
      return AppErrorView(error: state.error!);
    }

    if (state.transactions.isEmpty) {
      return TransactionsEmptyView(
        routeData: context_,
        hasActiveFilter: state.hasActiveFilter,
      );
    }

    final showProviderInfo = context_ is WorkspaceTransactionsRouteData;

    return TransactionsDateGroupedList(
      groupedTransactions: state.groupedTransactions,
      showProviderInfo: showProviderInfo,
      onTap: (tx) => TransactionDetailsBottomSheet.show(context, tx),
      footer: TransactionsLoadMoreFooter(routeData: context_),
    );
  }
}
