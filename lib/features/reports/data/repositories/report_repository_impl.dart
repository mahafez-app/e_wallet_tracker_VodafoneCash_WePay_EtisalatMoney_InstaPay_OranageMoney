import '../../../../core/utils/execute_and_handle_errors.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._remoteDataSource);

  final ReportRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ReportEntity>> getWalletReport({
    required String walletId,
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      executeAndHandleErrors(
          tag: 'ReportRepository.getWalletReport',
          () => _remoteDataSource.getWalletReport(
            walletId: walletId,
            startDate: startDate,
            endDate: endDate,
          ));

  @override
  Future<Result<ReportEntity>> getWorkspaceReport({
    required String workspaceId,
    required List<String> walletIds,
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      executeAndHandleErrors(
          tag: 'ReportRepository.getWorkspaceReport',
          () => _remoteDataSource.getWorkspaceReport(
            workspaceId: workspaceId,
            walletIds: walletIds,
            startDate: startDate,
            endDate: endDate,
          ));
}
