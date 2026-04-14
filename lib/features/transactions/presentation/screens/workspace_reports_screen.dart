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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.workspaceReportsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerLow.withAlpha(100),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: AppResponsive.onlyPadding(
              top: AppSpacing.md,
              bottom: AppSpacing.xxl,
            ),
            child: WorkspaceTransactionsOverviewSection(routeData: routeData),
          ),
        ),
      ),
    );
  }
}
