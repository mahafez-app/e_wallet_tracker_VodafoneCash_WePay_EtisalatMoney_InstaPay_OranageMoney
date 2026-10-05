import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_product/wallet_product.dart';
import '../data/repositories/report_repository_impl.dart';
import '../domain/repositories/report_repository.dart';
import '../domain/usecases/get_wallet_report_usecase.dart';
import '../domain/usecases/get_workspace_report_usecase.dart';

final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) =>
      ReportRepositoryImpl(ref.watch(getTransactionsReportUseCaseProvider)),
);

final getWalletReportUseCaseProvider = Provider<GetWalletReportUseCase>(
  (ref) => GetWalletReportUseCase(ref.watch(reportRepositoryProvider)),
);

final getWorkspaceReportUseCaseProvider = Provider<GetWorkspaceReportUseCase>(
  (ref) => GetWorkspaceReportUseCase(ref.watch(reportRepositoryProvider)),
);
