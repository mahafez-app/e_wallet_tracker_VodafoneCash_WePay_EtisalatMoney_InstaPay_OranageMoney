import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/providers/auth_providers.dart';
import '../providers/sms_permission_controller.dart';
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
    if (user == null) return const AppLoader();

    final authState = ref.watch(authNotifierProvider);
    final smsPermissionState = ref.watch(smsPermissionControllerProvider);
    final smsPermissionController = ref.read(
      smsPermissionControllerProvider.notifier,
    );

    return SingleChildScrollView(
      padding: AppResponsive.onlyPadding(
        start: AppSpacing.lg,
        top: AppSpacing.md,
        end: AppSpacing.lg,
        bottom: AppSpacing.xxxl,
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
              AppSpacing.lg.verticalSpace,
              UserSettingsAppSection(
                smsPermissionState: smsPermissionState,
                onOpenSmsSettings: smsPermissionController.openSettings,
              ),
              AppSpacing.lg.verticalSpace,
              UserSettingsAccountSection(
                isSigningOut:
                    authState.loadingMethod == AuthLoadingMethod.signOut,
              ),
              AppSpacing.lg.verticalSpace,
              const UserSettingsWalletsSection(),
              AppSpacing.lg.verticalSpace,
              SettingsSectionTitle(
                label: context.l10n.userSettingsAboutSection,
              ),
              AppSpacing.sm.verticalSpace,
              const SettingsAppVersionCard(),
            ],
          ),
        ),
      ),
    );
  }
}
