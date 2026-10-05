import 'package:mahafez_core/mahafez_core.dart';
import '../entities/report_entity.dart';
import '../repositories/report_repository.dart';

class GetWorkspaceReportUseCase
    implements UseCase<ReportEntity, GetWorkspaceReportParams> {
  const GetWorkspaceReportUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Future<Result<ReportEntity>> call(GetWorkspaceReportParams params) =>
      _repository.getWorkspaceReport(
        workspaceId: params.workspaceId,
        walletIds: params.walletIds,
        startDate: params.startDate,
        endDate: params.endDate,
      );
}

class GetWorkspaceReportParams {
  const GetWorkspaceReportParams({
    required this.workspaceId,
    required this.walletIds,
    required this.startDate,
    required this.endDate,
  });

  final String workspaceId;
  final List<String> walletIds;
  final DateTime startDate;
  final DateTime endDate;
}
