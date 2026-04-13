import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_color_extension.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../domain/enums/app_language_preference.dart';
import '../../domain/enums/app_theme_preference.dart';
import '../providers/app_preferences_controller.dart';
import '../providers/sms_permission_controller.dart';
import 'settings_card.dart';
import 'settings_compact_tile.dart';
import 'settings_option_bottom_sheet.dart';
import 'settings_section_title.dart';

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
        AppSpacing.sm.verticalSpace,
        SettingsCard(
          child: Column(
            children: [
              SettingsCompactTile(
                icon: Icons.sms_outlined,
                title: context.l10n.userSettingsSmsPermissionTitle,
                trailingLabel: _statusLabel(context),
                trailingLabelColor: _statusColor(context),
                isLoading: smsPermissionState.isOpeningSettings,
                onTap: onOpenSmsSettings,
              ),
              Padding(
                padding: AppResponsive.horizontalPadding(AppSpacing.lg),
                child: Divider(
                  height: 1.responsiveHeight,
                  thickness: 1.responsiveHeight,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              SettingsCompactTile(
                icon: Icons.palette_outlined,
                title: context.l10n.userSettingsThemeTitle,
                trailingLabel: _themeLabel(
                  context,
                  appPreferences.themePreference,
                ),
                onTap: () => _showThemeSelectionSheet(
                  context,
                  ref,
                  appPreferences.themePreference,
                ),
              ),
              Padding(
                padding: AppResponsive.horizontalPadding(AppSpacing.lg),
                child: Divider(
                  height: 1.responsiveHeight,
                  thickness: 1.responsiveHeight,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              SettingsCompactTile(
                icon: Icons.language_rounded,
                title: context.l10n.userSettingsLanguageTitle,
                trailingLabel: _languageLabel(
                  context,
                  appPreferences.languagePreference,
                ),
                onTap: () => _showLanguageSelectionSheet(
                  context,
                  ref,
                  appPreferences.languagePreference,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showThemeSelectionSheet(
    BuildContext context,
    WidgetRef ref,
    AppThemePreference selectedPreference,
  ) async {
    final selectedTheme =
        await SettingsOptionBottomSheet.show<AppThemePreference>(
          context,
          title: context.l10n.userSettingsThemeTitle,
          selectedValue: selectedPreference,
          options: [
            SettingsOption(
              value: AppThemePreference.system,
              label: context.l10n.userSettingsThemeSystemOption,
              icon: Icons.brightness_auto_rounded,
            ),
            SettingsOption(
              value: AppThemePreference.light,
              label: context.l10n.userSettingsThemeLightOption,
              icon: Icons.light_mode_rounded,
            ),
            SettingsOption(
              value: AppThemePreference.dark,
              label: context.l10n.userSettingsThemeDarkOption,
              icon: Icons.dark_mode_rounded,
            ),
          ],
        );

    if (selectedTheme == null || !context.mounted) {
      return;
    }

    ref
        .read(appPreferencesControllerProvider.notifier)
        .setThemePreference(selectedTheme);
  }

  Future<void> _showLanguageSelectionSheet(
    BuildContext context,
    WidgetRef ref,
    AppLanguagePreference selectedPreference,
  ) async {
    final selectedLanguage =
        await SettingsOptionBottomSheet.show<AppLanguagePreference>(
          context,
          title: context.l10n.userSettingsLanguageTitle,
          selectedValue: selectedPreference,
          options: [
            SettingsOption(
              value: AppLanguagePreference.system,
              label: context.l10n.userSettingsLanguageSystemOption,
              icon: Icons.settings_suggest_rounded,
            ),
            SettingsOption(
              value: AppLanguagePreference.english,
              label: context.l10n.userSettingsLanguageEnglishOption,
              icon: Icons.translate_rounded,
            ),
            SettingsOption(
              value: AppLanguagePreference.arabic,
              label: context.l10n.userSettingsLanguageArabicOption,
              icon: Icons.translate_rounded,
            ),
          ],
        );

    if (selectedLanguage == null || !context.mounted) {
      return;
    }

    ref
        .read(appPreferencesControllerProvider.notifier)
        .setLanguagePreference(selectedLanguage);
  }

  String _statusLabel(BuildContext context) {
    if (smsPermissionState.isChecking) {
      return context.l10n.userSettingsSmsPermissionCheckingLabel;
    }

    return smsPermissionState.hasPermission
        ? context.l10n.userSettingsSmsPermissionEnabledLabel
        : context.l10n.userSettingsSmsPermissionDisabledLabel;
  }

  Color _statusColor(BuildContext context) {
    if (smsPermissionState.isChecking) {
      return Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return smsPermissionState.hasPermission
        ? context.appColors.success
        : Theme.of(context).colorScheme.error;
  }

  String _themeLabel(BuildContext context, AppThemePreference preference) {
    return switch (preference) {
      AppThemePreference.system => context.l10n.userSettingsThemeSystemOption,
      AppThemePreference.light => context.l10n.userSettingsThemeLightOption,
      AppThemePreference.dark => context.l10n.userSettingsThemeDarkOption,
    };
  }

  String _languageLabel(
    BuildContext context,
    AppLanguagePreference preference,
  ) {
    return switch (preference) {
      AppLanguagePreference.system =>
        context.l10n.userSettingsLanguageSystemOption,
      AppLanguagePreference.english =>
        context.l10n.userSettingsLanguageEnglishOption,
      AppLanguagePreference.arabic =>
        context.l10n.userSettingsLanguageArabicOption,
    };
  }
}
