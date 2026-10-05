import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/balance_card.dart';
import '../../../../auth/providers/auth_providers.dart';
import '../../../domain/entities/wallet_details_entity.dart';
import '../../providers/wallet_details_controller.dart';
import 'edit_wallet_balance_bottom_sheet.dart';
import 'manual_wallet_transaction_bottom_sheet.dart';

class WalletBalanceSection extends ConsumerWidget {
  const WalletBalanceSection({super.key, required this.details});

  final WalletDetailsEntity details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final wallet = details.wallet;
    final localizedLastUpdate = wallet.lastBalanceAt.toFormattedDate(context);

    final currentUser = ref.watch(currentUserProvider);
    final isOwner = currentUser?.uid == wallet.ownerUid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BalanceCard(
          balance: wallet.currentBalance,
          sentAmount: wallet.totalSent,
          receivedAmount: wallet.totalReceived,
          statsResetDate: wallet.statsResetAt,
          label: l10n.currentBalance,
          subtitle: Text(
            '${l10n.lastActivity}: $localizedLastUpdate',
            style: theme.textTheme.labelMedium?.copyWith(
              color: context.mahafezColors.statsOnGradient.withAlpha(204),
            ),
          ),
          onReset: isOwner ? () => _handleReset(context, ref) : null,
        ),
        if (isOwner) ...[
          MahafezSpacing.sm.verticalSpace,
          MahafezButton(
            label: l10n.walletManualTransactionEntryAction,
            icon: const Icon(Icons.sms_rounded),
            onPressed: () => ManualWalletTransactionBottomSheet.show(
              context,
              walletId: wallet.id,
            ),
          ),
          MahafezSpacing.sm.verticalSpace,
          MahafezButton(
            label: l10n.walletBalanceEditAction,
            type: MahafezButtonType.secondary,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => EditWalletBalanceBottomSheet.show(
              context,
              walletId: wallet.id,
              currentBalance: wallet.currentBalance,
              suggestedBalance: details.suggestedBalance,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _handleReset(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await MahafezDialog.show<bool>(
      context,
      title: l10n.wallet_resetStats,
      message: l10n.wallet_resetStatsDescription,
      confirmLabel: l10n.wallet_resetStatsAction,
      cancelLabel: l10n.commonCancelAction,
      type: MahafezDialogType.warning,
      onConfirm: () => Navigator.pop(context, true),
    );

    if (confirmed == true) {
      await ref
          .read(walletDetailsControllerProvider(details.wallet.id).notifier)
          .resetStats();
    }
  }
}
