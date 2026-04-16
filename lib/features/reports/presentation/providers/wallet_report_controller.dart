
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/report_period.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/entities/report_filter_entity.dart';
import '../../domain/usecases/get_wallet_report_usecase.dart';
import '../../providers/reports_providers.dart';

class WalletReportFilterController extends Notifier<ReportFilterEntity> {
  WalletReportFilterController(this.walletId);
  final String walletId;

  @override
  ReportFilterEntity build() {
    return const ReportFilterEntity(period: ReportPeriod.today);
  }

  void updateFilter(ReportFilterEntity newFilter) {
    state = newFilter;
  }
}

final walletReportFilterProvider =
    NotifierProvider.family<WalletReportFilterController, ReportFilterEntity, String>(
  WalletReportFilterController.new,
);

final walletReportControllerProvider = AsyncNotifierProvider.family<
    WalletReportController, ReportEntity, String>(
  WalletReportController.new,
);

class WalletReportController extends AsyncNotifier<ReportEntity> {
  WalletReportController(this.walletId);
  final String walletId;

  @override
  Future<ReportEntity> build() async {
    final filter = ref.watch(walletReportFilterProvider(walletId));
    return _fetchReport(filter);
  }

  Future<ReportEntity> _fetchReport(ReportFilterEntity filter) async {
    final useCase = ref.read(getWalletReportUseCaseProvider);

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

    final result = await useCase(GetWalletReportParams(
      walletId: walletId,
      startDate: startDate,
      endDate: endDate,
    ));

    return result.fold(
      (failure) => throw failure,
      (report) => report,
    );
  }

  void updateFilter(ReportFilterEntity newFilter) {
    ref.read(walletReportFilterProvider(walletId).notifier).updateFilter(newFilter);
  }
}
