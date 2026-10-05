import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../core/widgets/wallets/app_wallet_tile.dart';
import '../providers/user_settings_wallets_controller.dart';
import '../providers/user_settings_wallets_state.dart';
import 'settings_section_title.dart';

class UserSettingsWalletsSection extends ConsumerWidget {
  const UserSettingsWalletsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userSettingsWalletsControllerProvider);
    final controller = ref.read(userSettingsWalletsControllerProvider.notifier);

    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: MahafezLoader(),
      );
    }

    if (state.wallets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionTitle(label: context.l10n.userSettingsWalletsSection),
        MahafezSpacing.xs.verticalSpace,
        Padding(
          padding: MahafezResponsive.horizontalPadding(MahafezSpacing.sm),
          child: Text(
            context.l10n.userSettingsWalletsDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        MahafezSpacing.sm.verticalSpace,
        ...state.wallets.map(
          (wallet) => Padding(
            padding: MahafezResponsive.onlyPadding(bottom: MahafezSpacing.md),
            child: AppWalletTile(
              wallet: wallet,
              onActionPressed: () => _showDeleteDialog(
                context,
                controller,
                wallet,
              ),
              actionIcon: Icons.delete_forever_rounded,
              actionTooltip: context.l10n.userSettingsDeleteWalletAction,
              isActionLoading: state.activeWalletId == wallet.id &&
                  state.action == UserSettingsWalletsAction.deletingWallet,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    UserSettingsWalletsController controller,
    WalletEntity wallet,
  ) {
    MahafezDialog.show(
      context,
      type: MahafezDialogType.error,
      title: context.l10n.userSettingsDeleteWalletConfirmTitle,
      message: context.l10n.userSettingsDeleteWalletConfirmMessage(
        wallet.provider.displayName(context),
        wallet.phoneNumber.formattedEgyptianPhoneNumber,
      ),
      confirmLabel: context.l10n.commonDeleteAction,
      cancelLabel: context.l10n.commonCancelAction,
      onConfirm: () {
        Navigator.pop(context);
        controller.deleteWallet(wallet.id);
      },
    );
  }
}
