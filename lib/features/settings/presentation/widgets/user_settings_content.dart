import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/providers/auth_providers.dart';
import '../providers/sms_permission_controller.dart';
import 'background_reliability_section.dart';
import 'edit_display_name_bottom_sheet.dart';
import 'settings_app_version_card.dart';
import 'settings_profile_card.dart';
import 'settings_section_title.dart';
import 'user_settings_account_section.dart';
import 'user_settings_app_section.dart';
import 'user_settings_wallets_section.dart';

class UserSettingsContent extends ConsumerWidget {
  const UserSettingsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const MahafezLoader();

    final authState = ref.watch(authNotifierProvider);
    final smsPermissionState = ref.watch(smsPermissionControllerProvider);
    final smsPermissionController = ref.read(
      smsPermissionControllerProvider.notifier,
    );

    return SingleChildScrollView(
      padding: MahafezResponsive.onlyPadding(
        start: MahafezSpacing.lg,
        top: MahafezSpacing.md,
        end: MahafezSpacing.lg,
        bottom: MahafezSpacing.xxxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 680.responsiveWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SettingsProfileCard(
                user: user,
                onEditName: () => EditDisplayNameBottomSheet.show(
                  context,
                  currentName: user.name,
                ),
              ),
              MahafezSpacing.lg.verticalSpace,
              UserSettingsAppSection(
                smsPermissionState: smsPermissionState,
                onOpenSmsSettings: smsPermissionController.openSettings,
              ),
              MahafezSpacing.lg.verticalSpace,
              const BackgroundReliabilitySection(),
              MahafezSpacing.lg.verticalSpace,
              UserSettingsAccountSection(
                isSigningOut:
                    authState.loadingMethod == AuthLoadingMethod.signOut,
              ),
              MahafezSpacing.lg.verticalSpace,
              const UserSettingsWalletsSection(),
              MahafezSpacing.lg.verticalSpace,
              SettingsSectionTitle(
                label: context.l10n.userSettingsAboutSection,
              ),
              MahafezSpacing.sm.verticalSpace,
              const SettingsAppVersionCard(),
            ],
          ),
        ),
      ),
    );
  }
}
