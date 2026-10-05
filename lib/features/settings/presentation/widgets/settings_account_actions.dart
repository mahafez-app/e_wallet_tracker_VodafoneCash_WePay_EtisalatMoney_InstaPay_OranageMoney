import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import 'settings_action_tile.dart';
import 'settings_card.dart';

class SettingsAccountActions extends StatelessWidget {
  const SettingsAccountActions({
    super.key,
    required this.isSigningOut,
    required this.onSignOut,
    required this.onDeleteAccount,
  });

  final bool isSigningOut;
  final VoidCallback onSignOut;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: Column(
        children: [
          SettingsActionTile(
            icon: Icons.logout_rounded,
            label: context.l10n.userSettingsSignOutAction,
            onTap: onSignOut,
            isLoading: isSigningOut,
          ),
          Padding(
            padding: MahafezResponsive.symmetricPadding(horizontal: MahafezSpacing.lg),
            child: Divider(
              height: 1.responsiveHeight,
              thickness: 1.responsiveHeight,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          SettingsActionTile(
            icon: Icons.delete_outline_rounded,
            label: context.l10n.userSettingsDeleteAccountAction,
            onTap: onDeleteAccount,
            isDanger: true,
          ),
        ],
      ),
    );
  }
}
