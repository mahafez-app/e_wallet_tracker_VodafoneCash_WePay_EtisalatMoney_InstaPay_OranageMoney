import '../../../../core/domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/execute_and_handle_errors.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/transaction_history_entry_entity.dart';
import '../../domain/entities/transaction_page.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_data_source.dart';

final class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({
    required TransactionRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final TransactionRemoteDataSource _remoteDataSource;

  // ── Queries ──────────────────────────────────────────────────────────────

  @override
  Future<Result<TransactionPage>> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
    TransactionPageCursor? cursor,
  }) => executeAndHandleErrors(() async {
    final result = await _remoteDataSource.getWalletTransactions(
      walletId: walletId,
      type: type,
      dateRange: dateRange,
      limit: limit,
      cursor: cursor,
    );
    return TransactionPage(
      transactions: result.transactions.map((e) => e.toEntity()).toList(),
      totalCount: result.totalCount,
      nextCursor: result.nextCursor,
    );
  }, tag: 'TransactionRepository.getWalletTransactions');

  @override
  Future<Result<List<TransactionEntity>>> getWorkspaceTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionDateRange? dateRange,
    int limit = 20,
  }) => executeAndHandleErrors(() async {
    final dtos = await _remoteDataSource.getWorkspaceTransactions(
      walletIds: walletIds,
      type: type,
      dateRange: dateRange,
      limit: limit,
    );
    return dtos.map((e) => e.toEntity()).toList();
  }, tag: 'TransactionRepository.getWorkspaceTransactions');

  // ── Mutations ────────────────────────────────────────────────────────────

  @override
  Future<Result<void>> markAsPaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  }) => executeAndHandleErrors(
    () => _remoteDataSource.markAsPaid(
      walletId: walletId,
      transactionId: transactionId,
      userId: userId,
      userName: userName,
    ),
    tag: 'TransactionRepository.markAsPaid',
  );

  @override
  Future<Result<void>> markAsUnpaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  }) => executeAndHandleErrors(
    () => _remoteDataSource.markAsUnpaid(
      walletId: walletId,
      transactionId: transactionId,
      userId: userId,
      userName: userName,
    ),
    tag: 'TransactionRepository.markAsUnpaid',
  );

  @override
  Future<Result<void>> saveTransaction(TransactionEntity transaction) =>
      executeAndHandleErrors(
        () => _remoteDataSource.saveTransaction(transaction),
        tag: 'TransactionRepository.saveTransaction',
      );

  // ── Notes ────────────────────────────────────────────────────────────────

  @override
  Future<Result<void>> addNote({
    required String walletId,
    required String transactionId,
    required String text,
    required String userId,
    required String userName,
  }) => executeAndHandleErrors(
    () => _remoteDataSource.addNote(
      walletId: walletId,
      transactionId: transactionId,
      text: text,
      userId: userId,
      userName: userName,
    ),
    tag: 'TransactionRepository.addNote',
  );

  @override
  Future<Result<void>> editNote({
    required String walletId,
    required String transactionId,
    required String noteId,
    required String text,
  }) => executeAndHandleErrors(
    () => _remoteDataSource.editNote(
      walletId: walletId,
      transactionId: transactionId,
      noteId: noteId,
      text: text,
    ),
    tag: 'TransactionRepository.editNote',
  );

  @override
  Future<Result<void>> deleteNote({
    required String walletId,
    required String transactionId,
    required String noteId,
  }) => executeAndHandleErrors(
    () => _remoteDataSource.deleteNote(
      walletId: walletId,
      transactionId: transactionId,
      noteId: noteId,
    ),
    tag: 'TransactionRepository.deleteNote',
  );

  @override
  Stream<Result<List<NoteEntity>>> getNotes({
    required String walletId,
    required String transactionId,
  }) => executeStreamAndHandleErrors(
    () => _remoteDataSource
        .getNotes(walletId: walletId, transactionId: transactionId)
        .map((dtos) => dtos.map((d) => d.toEntity()).toList()),
    tag: 'TransactionRepository.getNotes',
  );

  @override
  Stream<Result<List<TransactionHistoryEntryEntity>>> getTransactionHistory({
    required String walletId,
    required String transactionId,
  }) => executeStreamAndHandleErrors(
    () => _remoteDataSource
        .getTransactionHistory(walletId: walletId, transactionId: transactionId)
        .map((dtos) => dtos.map((d) => d.toEntity()).toList()),
    tag: 'TransactionRepository.getTransactionHistory',
  );
}
