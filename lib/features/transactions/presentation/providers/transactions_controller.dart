import 'dart:async';
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

part 'transactions_controller_live_sync.dart';
part 'transactions_controller_pagination.dart';

final transactionsControllerProvider = NotifierProvider.autoDispose
    .family<TransactionsController, TransactionsState, TransactionsRouteData>(
      TransactionsController.new,
    );

class TransactionsController extends Notifier<TransactionsState>
    with _TransactionsControllerPagination, _TransactionsControllerLiveSync {
  TransactionsController(this.arg);

  static const int walletPageSize = 10;
  static const int workspacePageSize = 5;

  @override
  final TransactionsRouteData arg;
  bool _didScheduleInitialLoad = false;
  int _activeRequestId = 0;

  @override
  TransactionsState build() {
    bindTransactionUpdates();
    _scheduleInitialLoad();
    return const TransactionsState();
  }

  void _scheduleInitialLoad() {
    if (_didScheduleInitialLoad) return;
    _didScheduleInitialLoad = true;
    Future<void>(() => loadInitial(requestId: startRequest()));
  }

  @override
  int startRequest() => ++_activeRequestId;

  @override
  bool isStaleRequest(int requestId) =>
      !ref.mounted || requestId != _activeRequestId;

  @override
  int resolvePageSize(TransactionsRouteData routeData) => switch (routeData) {
    WalletTransactionsRouteData() => walletPageSize,
    WorkspaceTransactionsRouteData() => workspacePageSize,
  };

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    switch (arg) {
      case WalletTransactionsRouteData():
        await loadWalletPage(
          arg as WalletTransactionsRouteData,
          isFirstPage: false,
          requestId: _activeRequestId,
        );
      case WorkspaceTransactionsRouteData():
        await loadWorkspacePage(
          arg as WorkspaceTransactionsRouteData,
          isFirstPage: false,
          requestId: _activeRequestId,
        );
    }
  }

  Future<void> setTypeFilter(TransactionTypeFilter filter) async {
    if (state.typeFilter == filter) return;
    state = state.copyWith(typeFilter: filter);
    await loadInitial(requestId: startRequest());
  }

  Future<void> setDatePreset(
    DatePreset preset, {
    DateTime? start,
    DateTime? end,
  }) async {
    if (preset == DatePreset.custom) {
      await setCustomDatePreset(start: start, end: end);
      return;
    }
    if (state.datePreset == preset) {
      await clearDatePreset();
      return;
    }

    state = state.copyWith(datePreset: preset, customDateRange: null);
    await loadInitial(requestId: startRequest());
  }

  Future<void> clearDatePreset() async {
    if (state.datePreset == DatePreset.none && state.customDateRange == null) {
      return;
    }

    state = state.copyWith(datePreset: DatePreset.none, customDateRange: null);
    await loadInitial(requestId: startRequest());
  }

  Future<void> selectAllWallets() async {
    if (state.useAllWallets && state.selectedWalletIds.isEmpty) return;
    state = state.copyWith(
      useAllWallets: true,
      selectedWalletIds: const <String>[],
    );
    await loadInitial(requestId: startRequest());
  }

  Future<void> toggleWalletFilter(String walletId) async {
    if (arg is! WorkspaceTransactionsRouteData) return;

    final currentSelection = state.useAllWallets
        ? <String>{walletId}
        : state.selectedWalletIds.toSet();

    if (!state.useAllWallets && !currentSelection.add(walletId)) {
      currentSelection.remove(walletId);
    }

    state = _resolveWalletSelectionState(currentSelection);
    await loadInitial(requestId: startRequest());
  }

  TransactionsState _resolveWalletSelectionState(
    Set<String> selectedWalletIds,
  ) {
    if (selectedWalletIds.isEmpty) {
      return state.copyWith(
        useAllWallets: true,
        selectedWalletIds: const <String>[],
      );
    }

    final orderedSelection = (arg as WorkspaceTransactionsRouteData).wallets
        .where((wallet) => selectedWalletIds.contains(wallet.walletId))
        .map((wallet) => wallet.walletId)
        .toList();

    return state.copyWith(
      useAllWallets: false,
      selectedWalletIds: orderedSelection,
    );
  }

  Future<void> clearAllFilters() async {
    state = const TransactionsState();
    await loadInitial(requestId: startRequest());
  }
}
