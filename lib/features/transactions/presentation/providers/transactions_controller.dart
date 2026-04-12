import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/transaction_events_provider.dart';
import '../../domain/entities/transaction_page.dart';
import '../../domain/usecases/get_wallet_transactions_usecase.dart';
import '../../domain/usecases/get_workspace_transactions_usecase.dart';
import '../../providers/transactions_providers.dart';
import '../navigation/transactions_route_data.dart';
import 'transactions_state.dart';

final transactionsControllerProvider = NotifierProvider.autoDispose
    .family<TransactionsController, TransactionsState, TransactionsRouteData>(
      TransactionsController.new,
    );

class TransactionsController extends Notifier<TransactionsState> {
  TransactionsController(this.arg);

  final TransactionsRouteData arg;

  static const int _pageSize = 10;
  bool _didScheduleInitialLoad = false;
  int _activeRequestId = 0;

  @override
  TransactionsState build() {
    ref.listen(transactionUpdatesProvider, (_, updatedTx) {
      if (updatedTx == null) return;
      _applyUpdatedTransaction(updatedTx);
    });

    _scheduleInitialLoad();
    return const TransactionsState();
  }

  void _scheduleInitialLoad() {
    if (_didScheduleInitialLoad) return;
    _didScheduleInitialLoad = true;
    Future<void>(() => _loadInitial(requestId: _startRequest()));
  }

  void _applyUpdatedTransaction(TransactionEntity updatedTransaction) {
    final transactionIndex = state.transactions.indexWhere(
      (transaction) => transaction.id == updatedTransaction.id,
    );
    if (transactionIndex == -1) return;

    final updatedTransactions = List<TransactionEntity>.of(state.transactions);
    updatedTransactions[transactionIndex] = updatedTransaction;
    state = state.copyWith(transactions: updatedTransactions);
  }

  int _startRequest() => ++_activeRequestId;

  bool _isStaleRequest(int requestId) =>
      !ref.mounted || requestId != _activeRequestId;

  Future<void> _loadInitial({required int requestId}) async {
    state = state.copyWith(
      isLoadingInitial: true,
      isLoadingMore: false,
      error: null,
      transactions: [],
      totalCount: 0,
      nextCursor: null,
    );

    switch (arg) {
      case WalletTransactionsRouteData():
        await _loadWalletPage(
          arg as WalletTransactionsRouteData,
          isFirstPage: true,
          requestId: requestId,
        );
      case WorkspaceTransactionsRouteData():
        await _loadWorkspacePage(
          arg as WorkspaceTransactionsRouteData,
          isFirstPage: true,
          requestId: requestId,
        );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    switch (arg) {
      case WalletTransactionsRouteData():
        await _loadWalletPage(
          arg as WalletTransactionsRouteData,
          isFirstPage: false,
          requestId: _activeRequestId,
        );
      case WorkspaceTransactionsRouteData():
        await _loadWorkspacePage(
          arg as WorkspaceTransactionsRouteData,
          isFirstPage: false,
          requestId: _activeRequestId,
        );
    }
  }

  Future<void> _loadWalletPage(
    WalletTransactionsRouteData context, {
    required bool isFirstPage,
    required int requestId,
  }) async {
    final effectiveWalletId = state.selectedWalletId ?? context.walletId;

    final result = await ref.read(getWalletTransactionsUseCaseProvider)(
      GetWalletTransactionsParams(
        walletId: effectiveWalletId,
        type: state.resolvedType,
        dateRange: state.resolvedDateRange,
        limit: _pageSize,
        cursor: isFirstPage
            ? null
            : state.nextCursor as WalletTransactionsPageCursor?,
      ),
    );

    if (_isStaleRequest(requestId)) return;

    result.fold(
      (failure) {
        log('TransactionsController: $failure', name: 'Presentation');
        _setLoadFailure(failure);
      },
      (page) {
        _setWalletPageSuccess(
          transactions: page.transactions,
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          isFirstPage: isFirstPage,
        );
      },
    );
  }

  void _setLoadFailure(Failure failure) {
    state = state.copyWith(
      isLoadingInitial: false,
      isLoadingMore: false,
      error: failure,
    );
  }

  void _setWalletPageSuccess({
    required List<TransactionEntity> transactions,
    required int totalCount,
    required TransactionsPageCursor? nextCursor,
    required bool isFirstPage,
  }) {
    final mergedTransactions = isFirstPage
        ? transactions
        : [...state.transactions, ...transactions];
    state = state.copyWith(
      transactions: mergedTransactions,
      totalCount: totalCount,
      nextCursor: nextCursor,
      isLoadingInitial: false,
      isLoadingMore: false,
      error: null,
    );
  }

  Future<void> _loadWorkspacePage(
    WorkspaceTransactionsRouteData context, {
    required bool isFirstPage,
    required int requestId,
  }) async {
    final walletIds = _resolveWorkspaceWalletIds(context);

    final result = await ref.read(getWorkspaceTransactionsUseCaseProvider)(
      GetWorkspaceTransactionsParams(
        walletIds: walletIds,
        type: state.resolvedType,
        dateRange: state.resolvedDateRange,
        limit: _pageSize,
        cursor: isFirstPage
            ? null
            : state.nextCursor as WorkspaceTransactionsPageCursor?,
      ),
    );

    if (_isStaleRequest(requestId)) return;

    result.fold(
      (failure) {
        log('TransactionsController: $failure', name: 'Presentation');
        _setLoadFailure(failure);
      },
      (page) => _setWalletPageSuccess(
        transactions: page.transactions,
        totalCount: page.totalCount,
        nextCursor: page.nextCursor,
        isFirstPage: isFirstPage,
      ),
    );
  }

  List<String> _resolveWorkspaceWalletIds(
    WorkspaceTransactionsRouteData context,
  ) {
    final selectedWalletId = state.selectedWalletId;
    if (selectedWalletId != null) {
      return [selectedWalletId];
    }

    return context.wallets.map((wallet) => wallet.walletId).toList();
  }

  Future<void> setTypeFilter(TransactionTypeFilter filter) async {
    if (state.typeFilter == filter) return;
    state = state.copyWith(typeFilter: filter);
    await _loadInitial(requestId: _startRequest());
  }

  Future<void> setDatePreset(
    DatePreset preset, {
    DateTime? start,
    DateTime? end,
  }) async {
    if (preset == DatePreset.custom) {
      await _setCustomDatePreset(start: start, end: end);
      return;
    }

    if (state.datePreset == preset) {
      await clearDatePreset();
      return;
    }

    state = state.copyWith(datePreset: preset, customDateRange: null);
    await _loadInitial(requestId: _startRequest());
  }

  Future<void> _setCustomDatePreset({DateTime? start, DateTime? end}) async {
    if (start == null || end == null) return;
    state = state.copyWith(
      datePreset: DatePreset.custom,
      customDateRange: _DateRangeHelper.fromDates(start, end),
    );
    await _loadInitial(requestId: _startRequest());
  }

  Future<void> clearDatePreset() async {
    if (state.datePreset == DatePreset.none && state.customDateRange == null) {
      return;
    }

    state = state.copyWith(datePreset: DatePreset.none, customDateRange: null);
    await _loadInitial(requestId: _startRequest());
  }

  Future<void> setWalletFilter(String? walletId) async {
    if (state.selectedWalletId == walletId) return;
    state = state.copyWith(selectedWalletId: walletId);
    await _loadInitial(requestId: _startRequest());
  }

  Future<void> clearAllFilters() async {
    state = const TransactionsState();
    await _loadInitial(requestId: _startRequest());
  }
}

// Helper to build a full-day range from DateRangePicker output.
abstract final class _DateRangeHelper {
  static DateTimeRange fromDates(DateTime start, DateTime end) => DateTimeRange(
    start: DateTime(start.year, start.month, start.day),
    end: DateTime(end.year, end.month, end.day, 23, 59, 59),
  );
}
