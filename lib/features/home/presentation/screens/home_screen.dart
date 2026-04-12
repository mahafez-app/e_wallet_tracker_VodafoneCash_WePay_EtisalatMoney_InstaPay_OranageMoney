// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/sms_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/home_dashboard_entity.dart';
import '../providers/home_dashboard_provider.dart';
import '../widgets/home_global_stats_widget.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_wallets_section.dart';
import '../widgets/home_workspaces_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SafeArea(child: _HomeBody()),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep the SMS listener alive while this widget is mounted.
    ref.watch(smsTransactionListenerProvider);

    // Side-effect: prompt for SMS permission the first time data arrives.
    ref.listen(homeDashboardProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        ref
            .read(smsPermissionPromptControllerProvider.notifier)
            .checkAndPromptIfNeeded(
              hasWallets: value.wallets.isNotEmpty,
              navigate: () {
                if (context.mounted) context.push(AppRoutes.smsPermissions);
              },
            );
      }
    });

    return switch (ref.watch(homeDashboardProvider)) {
      AsyncLoading() => const AppLoader(),
      AsyncData(:final value) => _HomeDataView(
        dashboard: value,
        onRefresh: () async {
          ref.invalidate(homeDashboardProvider);
          await ref.read(homeDashboardProvider.future);
        },
      ),
      AsyncError(:final error) => AppErrorView(error: error),
    };
  }
}

class _HomeDataView extends StatelessWidget {
  const _HomeDataView({
    super.key,
    required this.dashboard,
    required this.onRefresh,
  });

  final HomeDashboardEntity dashboard;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeaderWidget(
              invitationsCount: dashboard.invitationsCount,
              onOpenInvitations: () => context.push(AppRoutes.invitations),
            ),
            Padding(
              padding: AppSpacing.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxl,
                children: [
                  HomeGlobalStatsWidget(
                    totalBalance: dashboard.totalBalance,
                    totalSent: dashboard.totalSent,
                    totalReceived: dashboard.totalReceived,
                    walletCount: dashboard.wallets.length,
                  ),
                  HomeWalletsSection(wallets: dashboard.wallets),
                  HomeWorkspacesSection(workspaces: dashboard.workspaces),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
