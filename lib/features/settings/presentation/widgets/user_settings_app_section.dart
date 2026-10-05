import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../providers/app_preferences_controller.dart';
import '../providers/sms_permission_controller.dart';
import 'font_size_settings_bottom_sheet.dart';
import 'settings_card.dart';
import 'settings_compact_tile.dart';
import 'settings_section_title.dart';
import 'user_settings_app_section_helpers.dart';

class UserSettingsAppSection extends ConsumerWidget {
  const UserSettingsAppSection({
    super.key,
    required this.smsPermissionState,
    required this.onOpenSmsSettings,
  });

  final SmsPermissionState smsPermissionState;
  final VoidCallback onOpenSmsSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appPreferencesState = ref.watch(appPreferencesControllerProvider);
    final appPreferences = appPreferencesState.preferences;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionTitle(label: context.l10n.userSettingsAppSection),
        MahafezSpacing.sm.verticalSpace,
        SettingsCard(
          child: Column(
            children: [
              SettingsCompactTile(
                icon: Icons.sms_outlined,
                title: context.l10n.userSettingsSmsPermissionTitle,
                trailingLabel: settingsSmsStatusLabel(
                  context,
                  smsPermissionState,
                ),
                trailingLabelColor: settingsSmsStatusColor(
                  context,
                  smsPermissionState,
                ),
                isLoading: smsPermissionState.isOpeningSettings,
                onTap: onOpenSmsSettings,
              ),
              const SettingsTileDivider(),
              SettingsCompactTile(
                icon: Icons.palette_outlined,
                title: context.l10n.userSettingsThemeTitle,
                trailingLabel: settingsThemeLabel(
                  context,
                  appPreferences.themePreference,
                ),
                onTap: () => showThemeSelectionSheet(
                  context,
                  ref,
                  appPreferences.themePreference,
                ),
              ),
              const SettingsTileDivider(),
              SettingsCompactTile(
                icon: Icons.language_rounded,
                title: context.l10n.userSettingsLanguageTitle,
                trailingLabel: settingsLanguageLabel(
                  context,
                  appPreferences.languagePreference,
                ),
                onTap: () => showLanguageSelectionSheet(
                  context,
                  ref,
                  appPreferences.languagePreference,
                ),
              ),
              const SettingsTileDivider(),
              SettingsCompactTile(
                icon: Icons.format_size_rounded,
                title: context.l10n.userSettingsFontSizeTitle,
                trailingLabel: settingsFontScaleLabel(appPreferences.fontScale),
                onTap: () => FontSizeSettingsBottomSheet.show(
                  context,
                  initialFontScale: appPreferences.fontScale,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
