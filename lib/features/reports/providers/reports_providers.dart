import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../data/datasources/report_remote_data_source.dart';
import '../data/repositories/report_repository_impl.dart';
import '../domain/repositories/report_repository.dart';
import '../domain/usecases/get_wallet_report_usecase.dart';
import '../domain/usecases/get_workspace_report_usecase.dart';

final reportRemoteDataSourceProvider = Provider<ReportRemoteDataSource>(
  (ref) => ReportRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
  ),
);

final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => ReportRepositoryImpl(ref.watch(reportRemoteDataSourceProvider)),
);

final getWalletReportUseCaseProvider = Provider<GetWalletReportUseCase>(
  (ref) => GetWalletReportUseCase(ref.watch(reportRepositoryProvider)),
);

final getWorkspaceReportUseCaseProvider = Provider<GetWorkspaceReportUseCase>(
  (ref) => GetWorkspaceReportUseCase(ref.watch(reportRepositoryProvider)),
);
