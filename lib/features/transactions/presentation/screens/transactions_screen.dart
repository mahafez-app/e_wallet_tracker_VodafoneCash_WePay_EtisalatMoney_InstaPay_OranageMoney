// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../navigation/transactions_route_data.dart';
import '../providers/transactions_controller.dart';
import '../widgets/details/transaction_details_bottom_sheet.dart';
import '../widgets/filter_bar/transactions_filter_bottom_sheet.dart';
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
        actions: [
          if (transactionsContext is WorkspaceTransactionsRouteData)
            _ReportsIconButton(
              routeData: transactionsContext as WorkspaceTransactionsRouteData,
            ),
          _FilterIconButton(routeData: transactionsContext),
          AppSpacing.xs.horizontalSpace,
        ],
      ),
      body: SafeArea(child: _TransactionsBody(context_: transactionsContext)),
    );
  }
}

// ── AppBar title ──────────────────────────────────────────────────────────────

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

// ── Filter icon in AppBar ────────────────────────────────────────────────────

class _FilterIconButton extends ConsumerWidget {
  const _FilterIconButton({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCount = ref.watch(
      transactionsControllerProvider(
        routeData,
      ).select((s) => s.activeFilterCount),
    );

    return Padding(
      padding: AppResponsive.symmetricPadding(horizontal: 4),
      child: Badge(
        isLabelVisible: activeCount > 0,
        label: Text('$activeCount'),
        child: GestureDetector(
          child: Padding(
            padding: AppResponsive.symmetricPadding(horizontal: 4, vertical: 2),
            child: Icon(
              Icons.tune_rounded,
              semanticLabel: context.l10n.transactions_filterTitle,
            ),
          ),
          onTap: () => TransactionsFilterBottomSheet.show(context, routeData),
        ),
      ),
    );
  }
}

// ── Reports icon in AppBar ───────────────────────────────────────────────────

class _ReportsIconButton extends StatelessWidget {
  const _ReportsIconButton({super.key, required this.routeData});

  final WorkspaceTransactionsRouteData routeData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bar_chart_rounded),
      tooltip: context.l10n.workspaceReportsAction,
      onPressed: () {
        context.push(
          AppRoutes.workspaceReportsPath(routeData.workspaceId),
          extra: routeData,
        );
      },
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

    return _TransactionsContent(context_: context_);
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
