import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:wallet_product/wallet_product.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../workspaces/presentation/providers/workspace_details_controller.dart';

/// Composes workspace-owned wallet metadata into the wallet product's report UI.
class WorkspaceReportScreen extends ConsumerWidget {
  const WorkspaceReportScreen({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(
      workspaceDetailsControllerProvider(workspaceId),
    );
    return switch (workspace) {
      AsyncLoading() => const Scaffold(body: Center(child: MahafezLoader())),
      AsyncError(:final error) => Scaffold(
        body: Padding(
          padding: MahafezSpacing.pagePadding,
          child: Center(child: MahafezErrorView(error: error)),
        ),
      ),
      AsyncData(:final value) => WalletTransactionReportScreen(
        walletIds: value.wallets.map((wallet) => wallet.id).toList(),
        walletOptions: value.wallets
            .map(
              (wallet) => WalletReportOption(
                id: wallet.id,
                label:
                    '${wallet.provider.displayName(context)} ${wallet.phoneNumber.formattedEgyptianPhoneNumber}',
              ),
            )
            .toList(),
        title: context.l10n.reports_workspace_title,
      ),
    };
  }
}
