import '../entities/transaction_date_range.dart';
import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../entities/history_entry_entity.dart';
import '../entities/note_entity.dart';

abstract interface class TransactionRepository {
  // ── Queries ─────────────────────────────────────────────────────────────

  /// Paginated list of transactions for a single wallet.
  /// [lastDocument] is the Firestore cursor for the next page.
  Future<Result<PaginatedTransactions>> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
    Object? lastCursor,
  });

  /// Merged + sorted list of transactions across multiple wallet IDs.
  Future<Result<List<TransactionEntity>>> getWorkspaceTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
  });

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

  Future<Result<void>> saveTransaction(TransactionEntity transaction);

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

  Stream<Result<List<HistoryEntryEntity>>> getHistory({
    required String walletId,
    required String transactionId,
  });
}

/// Wraps a page of transactions with its Firestore cursor.
final class PaginatedTransactions {
  const PaginatedTransactions({
    required this.transactions,
    required this.totalCount,
    this.lastCursor,
  });

  final List<TransactionEntity> transactions;

  /// Best-effort total from a count query; may be approximate.
  final int totalCount;

  /// Null when there are no more pages.
  final Object? lastCursor;

  bool get hasMore => lastCursor != null;
}
