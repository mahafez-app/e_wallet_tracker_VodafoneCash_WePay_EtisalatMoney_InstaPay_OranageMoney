import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import 'settings_account_actions.dart';
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
        AppSpacing.sm.verticalSpace,
        SettingsAccountActions(
          isSigningOut: isSigningOut,
          onSignOut: () => _showSignOutDialog(context, ref),
          onDeleteAccount: () => _showDeleteAccountConfirmDialog(context),
        ),
      ],
    );
  }

  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) {
    return AppDialog.show<void>(
      context,
      title: context.l10n.userSettingsSignOutConfirmTitle,
      message: context.l10n.userSettingsSignOutConfirmMessage,
      confirmLabel: context.l10n.userSettingsSignOutAction,
      cancelLabel: context.l10n.commonCancelAction,
      type: AppDialogType.warning,
      onConfirm: () {
        Navigator.of(context).pop();
        ref.read(authNotifierProvider.notifier).signOut();
      },
    );
  }

  Future<void> _showDeleteAccountConfirmDialog(BuildContext context) {
    return AppDialog.show<void>(
      context,
      title: context.l10n.userSettingsDeleteAccountConfirmTitle,
      message: context.l10n.userSettingsDeleteAccountConfirmMessage,
      confirmLabel: context.l10n.commonDeleteAction,
      cancelLabel: context.l10n.commonCancelAction,
      type: AppDialogType.error,
      onConfirm: () {
        Navigator.of(context).pop();
        _showDeleteAccountUnavailableDialog(context);
      },
    );
  }

  Future<void> _showDeleteAccountUnavailableDialog(BuildContext context) {
    return AppDialog.show<void>(
      context,
      title: context.l10n.userSettingsDeleteAccountUnavailableTitle,
      message: context.l10n.userSettingsDeleteAccountUnavailableMessage,
      confirmLabel: context.l10n.confirm,
      type: AppDialogType.info,
      onConfirm: () => Navigator.of(context).pop(),
    );
  }
}
