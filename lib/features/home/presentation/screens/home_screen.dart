// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/sms_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../settings/presentation/providers/sms_permission_controller.dart';
import '../../domain/entities/home_dashboard_entity.dart';
import '../providers/home_dashboard_provider.dart';
import '../widgets/home_global_stats_widget.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_loading_view.dart';
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
    final smsPermissionController = ref.read(
      smsPermissionControllerProvider.notifier,
    );
    final homeDashboardState = ref.watch(homeDashboardProvider);

    // Keep the SMS listener alive while this widget is mounted.
    ref.watch(smsTransactionListenerProvider);

    // Side-effect: prompt for SMS permission the first time data arrives.
    ref.listen(homeDashboardProvider, (_, next) {
      if (!_isCurrentRoute(context)) return;

      if (next case AsyncData(:final value)) {
        smsPermissionController.checkAndPromptIfNeeded(
          hasWallets: value.wallets.isNotEmpty,
          navigateToPermission: () {
            if (context.mounted && _isCurrentRoute(context)) {
              context.push(AppRoutes.smsPermissions);
            }
          },
        );
      }
    });
    ref.listen<SmsPermissionState>(smsPermissionControllerProvider, (
      previous,
      next,
    ) {
      if (next.error == null) return;

      MahafezSnackbar.show(
        context,
        message: next.error!.toLocalizedString(context),
        type: MahafezSnackbarType.error,
      );
      smsPermissionController.clearError();
    });

    return switch (homeDashboardState) {
      AsyncLoading() => const HomeLoadingView(),
      AsyncData(:final value) => _HomeDataView(
        dashboard: value,
        onRefresh: () async {
          ref.invalidate(homeDashboardProvider);
          await ref.read(homeDashboardProvider.future);
        },
      ),
      AsyncError(:final error) => MahafezErrorView(error: error),
    };
  }

  bool _isCurrentRoute(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent ?? false;
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
              onOpenSettings: () => context.push(AppRoutes.settings),
            ),
            Padding(
              padding: MahafezSpacing.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: MahafezSpacing.xxl,
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
