import 'package:mahafez_core/mahafez_core.dart';
import 'package:wallet_product/wallet_product.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._getTransactionsReportUseCase);

  final GetTransactionsReportUseCase _getTransactionsReportUseCase;

  @override
  Future<Result<ReportEntity>> getWalletReport({
    required String walletId,
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      _getReport(walletIds: [walletId], startDate: startDate, endDate: endDate);

  @override
  Future<Result<ReportEntity>> getWorkspaceReport({
    required String workspaceId,
    required List<String> walletIds,
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      _getReport(walletIds: walletIds, startDate: startDate, endDate: endDate);

  Future<Result<ReportEntity>> _getReport({
    required List<String> walletIds,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final result = await _getTransactionsReportUseCase(
      GetTransactionsReportParams(
        walletIds: walletIds,
        startDate: startDate,
        endDate: endDate,
      ),
    );
    return switch (result) {
      Success(:final data) => Success(
        ReportEntity(
          totalIncome: data.totalIncome,
          totalOutcome: data.totalOutcome,
          balanceChange: data.balanceChange,
          transactionCount: data.transactionCount,
          transactionsByDay: data.transactionsByDay,
          receivedTransactionCount: data.receivedTransactionCount,
          sentTransactionCount: data.sentTransactionCount,
        ),
      ),
      FailureResult(:final failure) => FailureResult(failure),
    };
  }
}
