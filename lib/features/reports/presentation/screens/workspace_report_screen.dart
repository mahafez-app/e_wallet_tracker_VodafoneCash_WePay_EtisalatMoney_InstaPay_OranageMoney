// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/report_entity.dart';
import '../providers/workspace_report_controller.dart';
import '../widgets/report_period_selector.dart';
import '../widgets/report_summary_card.dart';
import '../widgets/workspace_wallet_selector_chips.dart';

class WorkspaceReportScreen extends StatelessWidget {
  const WorkspaceReportScreen({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.reports_workspace_title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _WorkspaceReportBody(workspaceId: workspaceId),
      ),
    );
  }
}

class _WorkspaceReportBody extends ConsumerWidget {
  const _WorkspaceReportBody({required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workspaceReportControllerProvider(workspaceId));

    return Column(
      children: [
        ReportPeriodSelector(
          currentFilter: ref.watch(workspaceReportFilterProvider(workspaceId)),
          onFilterChanged: (newFilter) {
            ref
                .read(workspaceReportControllerProvider(workspaceId).notifier)
                .updateFilter(newFilter);
          },
        ),
        WorkspaceWalletSelectorChips(workspaceId: workspaceId),
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
