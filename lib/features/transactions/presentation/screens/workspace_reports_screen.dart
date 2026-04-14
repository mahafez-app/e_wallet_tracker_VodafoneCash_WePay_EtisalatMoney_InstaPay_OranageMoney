import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../navigation/transactions_route_data.dart';
import '../widgets/list/workspace_transactions_overview_section.dart';

class WorkspaceReportsScreen extends StatelessWidget {
  const WorkspaceReportsScreen({super.key, required this.routeData});

  final WorkspaceTransactionsRouteData routeData;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.workspaceReportsTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppResponsive.onlyPadding(top: AppSpacing.md),
          child: WorkspaceTransactionsOverviewSection(routeData: routeData),
        ),
      ),
    );
  }
}
