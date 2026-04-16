// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/report_entity.dart';
import '../providers/wallet_report_controller.dart';
import '../widgets/report_period_selector.dart';
import '../widgets/report_summary_card.dart';

class WalletReportScreen extends StatelessWidget {
  const WalletReportScreen({super.key, required this.walletId});

  final String walletId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.reports_wallet_title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _WalletReportBody(walletId: walletId),
      ),
    );
  }
}

class _WalletReportBody extends ConsumerWidget {
  const _WalletReportBody({required this.walletId});

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletReportControllerProvider(walletId));

    return Column(
      children: [
        ReportPeriodSelector(
          currentFilter: ref.watch(walletReportFilterProvider(walletId)),
          onFilterChanged: (newFilter) {
            ref
                .read(walletReportControllerProvider(walletId).notifier)
                .updateFilter(newFilter);
          },
        ),
        Expanded(
          child: switch (state) {
            AsyncLoading() => const Center(child: AppLoader()),
            AsyncData(:final value) => _ReportDataView(report: value),
            AsyncError(:final error) => Padding(
                padding: AppSpacing.pagePadding,
                child: AppErrorView(error: error),
              ),
          },
        ),
      ],
    );
  }
}

class _ReportDataView extends StatelessWidget {
  const _ReportDataView({super.key, required this.report});

  final ReportEntity report;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReportSummaryCard(report: report),
          AppSpacing.xl.verticalSpace,
        ],
      ),
    );
  }
}
