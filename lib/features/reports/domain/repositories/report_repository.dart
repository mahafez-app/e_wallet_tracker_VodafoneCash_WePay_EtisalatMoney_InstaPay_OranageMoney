import 'package:mahafez_core/mahafez_core.dart';
import '../entities/report_entity.dart';

abstract interface class ReportRepository {
  Future<Result<ReportEntity>> getWalletReport({
    required String walletId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Result<ReportEntity>> getWorkspaceReport({
    required String workspaceId,
    required List<String> walletIds,
    required DateTime startDate,
    required DateTime endDate,
  });
}
