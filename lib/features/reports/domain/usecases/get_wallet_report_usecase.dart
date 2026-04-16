import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/report_entity.dart';
import '../repositories/report_repository.dart';

class GetWalletReportUseCase
    implements UseCase<ReportEntity, GetWalletReportParams> {
  const GetWalletReportUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Future<Result<ReportEntity>> call(GetWalletReportParams params) =>
      _repository.getWalletReport(
        walletId: params.walletId,
        startDate: params.startDate,
        endDate: params.endDate,
      );
}

class GetWalletReportParams {
  const GetWalletReportParams({
    required this.walletId,
    required this.startDate,
    required this.endDate,
  });

  final String walletId;
  final DateTime startDate;
  final DateTime endDate;
}
