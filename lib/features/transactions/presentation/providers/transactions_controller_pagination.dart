part of 'transactions_controller.dart';

mixin _TransactionsControllerPagination on Notifier<TransactionsState> {
  TransactionsRouteData get arg;

  bool isStaleRequest(int requestId);

  int startRequest();

  int resolvePageSize(TransactionsRouteData routeData);

  Future<void> loadInitial({required int requestId}) async {
    state = state.copyWith(
      isLoadingInitial: true,
      isLoadingMore: false,
      error: null,
      transactions: const <TransactionEntity>[],
      totalCount: 0,
      nextCursor: null,
    );

    switch (arg) {
      case WalletTransactionsRouteData():
        await loadWalletPage(
          arg as WalletTransactionsRouteData,
          isFirstPage: true,
          requestId: requestId,
        );
      case WorkspaceTransactionsRouteData():
        await loadWorkspacePage(
          arg as WorkspaceTransactionsRouteData,
          isFirstPage: true,
          requestId: requestId,
        );
    }
  }

  Future<void> loadWalletPage(
    WalletTransactionsRouteData context, {
    required bool isFirstPage,
    required int requestId,
  }) async {
    final result = await ref.read(getWalletTransactionsUseCaseProvider)(
      GetWalletTransactionsParams(
        walletId: context.walletId,
        type: state.resolvedType,
        dateRange: state.resolvedDateRange,
        limit: resolvePageSize(context),
        cursor: isFirstPage
            ? null
            : state.nextCursor as WalletTransactionsPageCursor?,
      ),
    );

    if (isStaleRequest(requestId)) return;
    result.fold(setLoadFailure, (page) {
      setPageSuccess(page: page, isFirstPage: isFirstPage);
    });
  }

  Future<void> loadWorkspacePage(
    WorkspaceTransactionsRouteData context, {
    required bool isFirstPage,
    required int requestId,
  }) async {
    final result = await ref.read(getWorkspaceTransactionsUseCaseProvider)(
      GetWorkspaceTransactionsParams(
        walletIds: resolveWorkspaceWalletIds(context),
        type: state.resolvedType,
        dateRange: state.resolvedDateRange,
        limit: resolvePageSize(context),
        cursor: isFirstPage
            ? null
            : state.nextCursor as WorkspaceTransactionsPageCursor?,
      ),
    );

    if (isStaleRequest(requestId)) return;
    result.fold(setLoadFailure, (page) {
      setPageSuccess(page: page, isFirstPage: isFirstPage);
    });
  }

  List<String> resolveWorkspaceWalletIds(
    WorkspaceTransactionsRouteData context,
  ) {
    if (state.useAllWallets) {
      return context.wallets.map((wallet) => wallet.walletId).toList();
    }

    return context.wallets
        .where((wallet) => state.selectedWalletIds.contains(wallet.walletId))
        .map((wallet) => wallet.walletId)
        .toList();
  }

  void setLoadFailure(Failure failure) {
    log('TransactionsController: $failure', name: 'Presentation');
    state = state.copyWith(
      isLoadingInitial: false,
      isLoadingMore: false,
      error: failure,
    );
  }

  void setPageSuccess({
    required TransactionPage page,
    required bool isFirstPage,
  }) {
    final mergedTransactions = isFirstPage
        ? page.transactions
        : [...state.transactions, ...page.transactions];
    state = state.copyWith(
      transactions: mergedTransactions,
      totalCount: page.totalCount,
      nextCursor: page.nextCursor,
      isLoadingInitial: false,
      isLoadingMore: false,
      error: null,
    );
  }

  Future<void> setCustomDatePreset({DateTime? start, DateTime? end}) async {
    if (start == null || end == null) return;

    state = state.copyWith(
      datePreset: DatePreset.custom,
      customDateRange: _DateRangeHelper.fromDates(start, end),
    );
    await loadInitial(requestId: startRequest());
  }
}

abstract final class _DateRangeHelper {
  static DateTimeRange fromDates(DateTime start, DateTime end) => DateTimeRange(
    start: DateTime(start.year, start.month, start.day),
    end: DateTime(end.year, end.month, end.day, 23, 59, 59),
  );
}
