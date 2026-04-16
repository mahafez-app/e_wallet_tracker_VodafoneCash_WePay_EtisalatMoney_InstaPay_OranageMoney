
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/report_period.dart';
import '../../../workspaces/presentation/providers/workspace_details_controller.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/entities/report_filter_entity.dart';
import '../../domain/usecases/get_workspace_report_usecase.dart';
import '../../providers/reports_providers.dart';

class WorkspaceReportFilterController extends Notifier<ReportFilterEntity> {
  WorkspaceReportFilterController(this.workspaceId);
  final String workspaceId;

  @override
  ReportFilterEntity build() {
    return const ReportFilterEntity(period: ReportPeriod.today);
  }

  void updateFilter(ReportFilterEntity newFilter) {
    state = newFilter;
  }
}

final workspaceReportFilterProvider =
    NotifierProvider.family<WorkspaceReportFilterController, ReportFilterEntity, String>(
  WorkspaceReportFilterController.new,
);

final workspaceReportControllerProvider = AsyncNotifierProvider.family<
    WorkspaceReportController, ReportEntity, String>(
  WorkspaceReportController.new,
);

class WorkspaceReportController extends AsyncNotifier<ReportEntity> {
  WorkspaceReportController(this.workspaceId);
  final String workspaceId;

  @override
  Future<ReportEntity> build() async {
    final filter = ref.watch(workspaceReportFilterProvider(workspaceId));
    return _fetchReport(filter);
  }

  Future<ReportEntity> _fetchReport(ReportFilterEntity filter) async {
    final useCase = ref.read(getWorkspaceReportUseCaseProvider);
    
    // Auto-fetch workspace wallets if selectedWalletIds is empty
    List<String> walletsToQuery = filter.selectedWalletIds;
    if (walletsToQuery.isEmpty) {
        final workspaceAsync = ref.read(workspaceDetailsControllerProvider(workspaceId));
        if (workspaceAsync.hasValue) {
            walletsToQuery = workspaceAsync.value!.wallets.map((w) => w.id).toList();
        }
    }

    if (walletsToQuery.isEmpty) {
      return const ReportEntity(
        totalIncome: 0,
        totalOutcome: 0,
        balanceChange: 0,
        transactionCount: 0,
        transactionsByDay: {},
        receivedTransactionCount: 0,
        sentTransactionCount: 0,
      );
    }

    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (filter.period) {
      case ReportPeriod.today:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case ReportPeriod.yesterday:
        final yesterday = now.subtract(const Duration(days: 1));
        startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        endDate = DateTime(
            yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case ReportPeriod.lastWeek:
        final weekAgo = now.subtract(const Duration(days: 7));
        startDate = DateTime(weekAgo.year, weekAgo.month, weekAgo.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case ReportPeriod.lastMonth:
        final monthAgo = now.subtract(const Duration(days: 30));
        startDate = DateTime(monthAgo.year, monthAgo.month, monthAgo.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case ReportPeriod.customRange:
        startDate = filter.customRange?.start ??
            DateTime(now.year, now.month, now.day);
        endDate = filter.customRange?.end ??
            DateTime(now.year, now.month, now.day, 23, 59, 59);
        endDate = DateTime(
            endDate.year, endDate.month, endDate.day, 23, 59, 59);
        break;
    }

    final result = await useCase(GetWorkspaceReportParams(
      workspaceId: workspaceId,
      walletIds: walletsToQuery,
      startDate: startDate,
      endDate: endDate,
    ));

    return result.fold(
      (failure) => throw failure,
      (report) => report,
    );
  }

  void updateFilter(ReportFilterEntity newFilter) {
    ref.read(workspaceReportFilterProvider(workspaceId).notifier).updateFilter(newFilter);
  }
}
