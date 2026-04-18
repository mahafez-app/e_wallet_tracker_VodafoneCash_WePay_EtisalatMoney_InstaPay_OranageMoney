// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_tracker/core/widgets/wallets/wallet_provider_info.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/wallet_details_entity.dart';
import '../providers/wallet_details_controller.dart';
import '../widgets/wallet_details/wallet_balance_section.dart';
import '../widgets/wallet_details/wallet_recent_transactions_section.dart';

class WalletDetailsScreen extends StatelessWidget {
  const WalletDetailsScreen({super.key, required this.walletId});

  final String walletId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.walletDetails),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                context.push(AppRoutes.walletReportsPath(walletId)),
            icon: const Icon(Icons.bar_chart_rounded),
          ),
        ],
      ),
      body: SafeArea(child: _WalletDetailsBody(walletId: walletId)),
    );
  }
}

class _WalletDetailsBody extends ConsumerWidget {
  const _WalletDetailsBody({super.key, required this.walletId});

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletDetailsControllerProvider(walletId));

    return state.when(
      loading: () => const AppLoader(),
      error: (error, _) => AppErrorView(error: error),
      data: (details) => SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          children: [
            WalletBalanceSection(details: details),
            AppSpacing.md.verticalSpace,
            _WalletInfoSection(details: details),
            AppSpacing.md.verticalSpace,
            WalletRecentTransactionsSection(details: details),
          ],
        ),
      ),
    );
  }
}

class _WalletInfoSection extends StatelessWidget {
  const _WalletInfoSection({super.key, required this.details});

  final WalletDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final wallet = details.wallet;
    final colors = context.appColors;

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadiusDirectional.circular(20.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
      ),
      child: WalletProviderInfo(
        provider: wallet.provider,
        phoneNumber: wallet.phoneNumber,
        borderRadius: 8,
      ),
    );
  }
}
