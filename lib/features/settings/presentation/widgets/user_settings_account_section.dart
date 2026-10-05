import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import 'settings_card.dart';
import 'settings_compact_tile.dart';
import 'settings_section_title.dart';

class UserSettingsAccountSection extends ConsumerWidget {
  const UserSettingsAccountSection({super.key, required this.isSigningOut});

  final bool isSigningOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionTitle(label: context.l10n.userSettingsAccountSection),
        MahafezSpacing.sm.verticalSpace,
        SettingsCard(
          child: Column(
            children: [
              SettingsCompactTile(
                icon: Icons.logout_rounded,
                title: context.l10n.userSettingsSignOutAction,
                isLoading: isSigningOut,
                showChevron: false,
                onTap: () => _showSignOutDialog(context, ref),
              ),
              Padding(
                padding: MahafezResponsive.horizontalPadding(MahafezSpacing.lg),
                child: Divider(
                  height: 1.responsiveHeight,
                  thickness: 1.responsiveHeight,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              SettingsCompactTile(
                icon: Icons.delete_outline_rounded,
                title: context.l10n.userSettingsDeleteAccountAction,
                isDanger: true,
                showChevron: false,
                onTap: () => _showDeleteAccountConfirmDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) {
    return MahafezDialog.show<void>(
      context,
      title: context.l10n.userSettingsSignOutConfirmTitle,
      message: context.l10n.userSettingsSignOutConfirmMessage,
      confirmLabel: context.l10n.userSettingsSignOutAction,
      cancelLabel: context.l10n.commonCancelAction,
      type: MahafezDialogType.warning,
      onConfirm: () {
        Navigator.of(context).pop();
        ref.read(authNotifierProvider.notifier).signOut();
      },
    );
  }

  Future<void> _showDeleteAccountConfirmDialog(BuildContext context) {
    return MahafezDialog.show<void>(
      context,
      title: context.l10n.userSettingsDeleteAccountConfirmTitle,
      message: context.l10n.userSettingsDeleteAccountConfirmMessage,
      confirmLabel: context.l10n.commonDeleteAction,
      cancelLabel: context.l10n.commonCancelAction,
      type: MahafezDialogType.error,
      onConfirm: () {
        Navigator.of(context).pop();
        _showDeleteAccountUnavailableDialog(context);
      },
    );
  }

  Future<void> _showDeleteAccountUnavailableDialog(BuildContext context) {
    return MahafezDialog.show<void>(
      context,
      title: context.l10n.userSettingsDeleteAccountUnavailableTitle,
      message: context.l10n.userSettingsDeleteAccountUnavailableMessage,
      confirmLabel: context.l10n.confirm,
      type: MahafezDialogType.info,
      onConfirm: () => Navigator.of(context).pop(),
    );
  }
}
