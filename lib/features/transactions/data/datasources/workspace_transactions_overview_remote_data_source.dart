import 'package:mahafez_core/mahafez_core.dart';
import 'package:wallet_product/wallet_product.dart';

import '../../domain/entities/workspace_transactions_overview_entity.dart';
import '../models/workspace_transactions_overview_dto.dart';

abstract interface class WorkspaceTransactionsOverviewRemoteDataSource {
  Future<WorkspaceTransactionsOverviewDto> getWorkspaceTransactionsOverview({
    required List<String> walletIds,
  });
}

final class WorkspaceTransactionsOverviewRemoteDataSourceImpl
    implements WorkspaceTransactionsOverviewRemoteDataSource {
  const WorkspaceTransactionsOverviewRemoteDataSourceImpl({
    required TransactionFirestoreSupport support,
  }) : _support = support;

  final TransactionFirestoreSupport _support;

  @override
  Future<WorkspaceTransactionsOverviewDto> getWorkspaceTransactionsOverview({
    required List<String> walletIds,
  }) async {
    if (walletIds.isEmpty) {
      return const WorkspaceTransactionsOverviewDto(
        todayCollected: 0,
        todaySent: 0,
        unpaidCount: 0,
        latestActiveWallets: <WorkspaceActiveWalletEntity>[],
      );
    }

    final wallets = await _loadWallets(walletIds);
    if (wallets.isEmpty) {
      return const WorkspaceTransactionsOverviewDto(
        todayCollected: 0,
        todaySent: 0,
        unpaidCount: 0,
        latestActiveWallets: <WorkspaceActiveWalletEntity>[],
      );
    }

    final todayRange = _support.todayRange();
    final todayTransactionsByWallet = await Future.wait(
      wallets.map(
        (wallet) => _loadTodayTransactions(wallet: wallet, dateRange: todayRange),
      ),
    );
    final unpaidCounts = await Future.wait(
      wallets.map((wallet) => _countUnpaidTransactions(walletId: wallet.id)),
    );
    final allTodayTransactions = todayTransactionsByWallet.expand(
      (transactions) => transactions,
    );
    final latestActiveWallets = wallets.toList()
      ..sort((left, right) => right.lastBalanceAt.compareTo(left.lastBalanceAt));

    return WorkspaceTransactionsOverviewDto(
      todayCollected: allTodayTransactions
          .where((transaction) => transaction.type == TransactionType.receive)
          .fold<double>(0, (sum, transaction) => sum + transaction.amount),
      todaySent: allTodayTransactions
          .where((transaction) => transaction.type == TransactionType.send)
          .fold<double>(0, (sum, transaction) => sum + transaction.amount),
      unpaidCount: unpaidCounts.fold<int>(0, (sum, count) => sum + count),
      latestActiveWallets: latestActiveWallets
          .take(3)
          .map(
            (wallet) => WorkspaceActiveWalletDto(
              walletId: wallet.id,
              provider: wallet.provider,
              phoneNumber: wallet.phoneNumber,
              lastActivityAt: wallet.lastBalanceAt,
            ),
          )
          .toList(),
    );
  }

  Future<List<WalletDto>> _loadWallets(List<String> walletIds) async {
    final snapshots = await Future.wait(
      walletIds.map((walletId) => _support.walletDocument(walletId).get()),
    );

    return snapshots
        .where((snapshot) => snapshot.exists)
        .map(WalletDto.fromFirestore)
        .toList();
  }

  Future<List<TransactionDto>> _loadTodayTransactions({
    required WalletDto wallet,
    required TransactionDateRange dateRange,
  }) async {
    final snapshot = await _support
        .applyFilters(
          _support.walletTransactionsQuery(wallet.id),
          dateRange: dateRange,
        )
        .get();

    return snapshot.docs
        .map(
          (doc) => TransactionDto.fromFirestore(
            doc,
            wallet.provider,
            wallet.phoneNumber,
            wallet.id,
            wallet.ownerUid,
          ),
        )
        .toList();
  }

  Future<int> _countUnpaidTransactions({required String walletId}) async {
    final snapshot = await _support
        .applyFilters(
          _support.txCollection(walletId),
          type: TransactionType.receive,
          paidStatusFilter: TransactionPaidStatusFilter.unpaid,
        )
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
