import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_wallet_transactions_usecase.dart';
import '../../domain/usecases/get_workspace_transactions_usecase.dart';
import '../models/transactions_context.dart';
import '../../providers/transactions_providers.dart';
import 'transactions_state.dart';

final transactionUpdatesProvider =
    NotifierProvider.autoDispose<
      TransactionUpdatesNotifier,
      TransactionEntity?
    >(TransactionUpdatesNotifier.new);

class TransactionUpdatesNotifier extends Notifier<TransactionEntity?> {
  @override
  TransactionEntity? build() => null;

  void notifyUpdated(TransactionEntity tx) => state = tx;
}

final transactionsControllerProvider = NotifierProvider.autoDispose
    .family<TransactionsController, TransactionsState, TransactionsContext>(
      TransactionsController.new,
    );

class TransactionsController extends Notifier<TransactionsState> {
  TransactionsController(this.arg);

  final TransactionsContext arg;

  static const int _pageSize = 20;
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
      lastCursor: null,
    );

    switch (arg) {
      case WalletTransactionsContext():
        await _loadWalletPage(
          arg as WalletTransactionsContext,
          isFirstPage: true,
          requestId: requestId,
        );
      case WorkspaceTransactionsContext():
        await _loadWorkspacePage(
          arg as WorkspaceTransactionsContext,
          requestId: requestId,
        );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    if (arg is! WalletTransactionsContext) return;

    state = state.copyWith(isLoadingMore: true);
    await _loadWalletPage(
      arg as WalletTransactionsContext,
      isFirstPage: false,
      requestId: _activeRequestId,
    );
  }

  Future<void> _loadWalletPage(
    WalletTransactionsContext context, {
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
        lastCursor: isFirstPage ? null : state.lastCursor,
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
          lastCursor: page.lastCursor,
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
    required Object? lastCursor,
    required bool isFirstPage,
  }) {
    final mergedTransactions = isFirstPage
        ? transactions
        : [...state.transactions, ...transactions];
    state = state.copyWith(
      transactions: mergedTransactions,
      totalCount: totalCount,
      lastCursor: lastCursor,
      isLoadingInitial: false,
      isLoadingMore: false,
      error: null,
    );
  }

  Future<void> _loadWorkspacePage(
    WorkspaceTransactionsContext context, {
    required int requestId,
  }) async {
    final walletIds = _resolveWorkspaceWalletIds(context);

    final result = await ref.read(getWorkspaceTransactionsUseCaseProvider)(
      GetWorkspaceTransactionsParams(
        walletIds: walletIds,
        type: state.resolvedType,
        dateRange: state.resolvedDateRange,
      ),
    );

    if (_isStaleRequest(requestId)) return;

    result.fold(
      (failure) {
        log('TransactionsController: $failure', name: 'Presentation');
        _setLoadFailure(failure);
      },
      (transactions) {
        state = state.copyWith(
          transactions: transactions,
          totalCount: transactions.length,
          isLoadingInitial: false,
          error: null,
        );
      },
    );
  }

  List<String> _resolveWorkspaceWalletIds(
    WorkspaceTransactionsContext context,
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
    if (preset == DatePreset.custom && start != null && end != null) {
      final range = _DateRangeHelper.fromDates(start, end);
      state = state.copyWith(
        datePreset: DatePreset.custom,
        customDateRange: range,
      );
    } else {
      state = state.copyWith(datePreset: preset);
    }
    await _loadInitial(requestId: _startRequest());
  }

  Future<void> clearDatePreset() async {
    state = state.copyWith(datePreset: DatePreset.none);
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
