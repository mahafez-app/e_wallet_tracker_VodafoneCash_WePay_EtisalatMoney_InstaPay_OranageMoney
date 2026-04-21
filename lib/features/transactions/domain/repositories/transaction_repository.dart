import '../entities/transaction_date_range.dart';
import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../entities/transaction_history_entry_entity.dart';
import '../entities/note_entity.dart';
import '../entities/transaction_page.dart';
import '../entities/transaction_paid_status_filter.dart';
import '../entities/workspace_transactions_overview_entity.dart';

abstract interface class TransactionRepository {
  // ── Queries ─────────────────────────────────────────────────────────────

  /// Paginated list of transactions for a single wallet.
  /// [cursor] points to the next page when more data is available.
  Future<Result<TransactionPage>> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    WalletTransactionsPageCursor? cursor,
  });

  /// Merged + sorted list of transactions across multiple wallet IDs.
  Future<Result<TransactionPage>> getWorkspaceTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    WorkspaceTransactionsPageCursor? cursor,
  });

  Stream<Result<TransactionEntity>> watchTransaction({
    required String walletId,
    required String transactionId,
  });

  Future<Result<DateTime?>> getLatestTransactionDate(String walletId);

  // ── Mutations ────────────────────────────────────────────────────────────

  Future<Result<void>> markAsPaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  });

  Future<Result<void>> markAsUnpaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  });

  Future<Result<void>> saveTransaction(
    TransactionEntity transaction, {
    bool allowLocallyDeletedRestore = false,
  });

  Future<Result<WorkspaceTransactionsOverviewEntity>>
  getWorkspaceTransactionsOverview({required List<String> walletIds});

  Future<Result<void>> deleteTransaction({
    required String walletId,
    required String transactionId,
    required String userId,
  });

  // ── Notes ────────────────────────────────────────────────────────────────

  Future<Result<void>> addNote({
    required String walletId,
    required String transactionId,
    required String text,
    required String userId,
    required String userName,
  });

  Future<Result<void>> editNote({
    required String walletId,
    required String transactionId,
    required String noteId,
    required String text,
  });

  Future<Result<void>> deleteNote({
    required String walletId,
    required String transactionId,
    required String noteId,
  });

  Stream<Result<List<NoteEntity>>> getNotes({
    required String walletId,
    required String transactionId,
  });

  // ── History ──────────────────────────────────────────────────────────────

  Stream<Result<List<TransactionHistoryEntryEntity>>> getTransactionHistory({
    required String walletId,
    required String transactionId,
  });
}
