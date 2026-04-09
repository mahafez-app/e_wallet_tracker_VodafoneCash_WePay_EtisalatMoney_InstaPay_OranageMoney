import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../providers/home_controller.dart';
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
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(homeDashboardProvider);

    return switch (dashboardState) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncData(:final value) => RefreshIndicator(
        onRefresh: () async => ref.refresh(homeDashboardProvider),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeaderWidget(invitationsCount: value.invitationsCount),
              Padding(
                padding: AppSpacing.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxl,
                  children: [
                    HomeGlobalStatsWidget(
                      totalBalance: value.totalBalance,
                      totalSent: value.totalSent,
                      totalReceived: value.totalReceived,
                      walletCount: value.wallets.length,
                    ),
                    HomeWalletsSection(wallets: value.wallets),
                    HomeWorkspacesSection(workspaces: value.workspaces),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      AsyncError(:final error) => Center(child: Text(error.toString())),
    };
  }
}
