// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../providers/sms_permission_controller.dart';
import 'edit_display_name_bottom_sheet.dart';
import 'settings_account_actions.dart';
import 'settings_app_version_card.dart';
import 'settings_profile_card.dart';
import 'settings_section_title.dart';
import 'settings_sms_permission_card.dart';

class UserSettingsBody extends ConsumerStatefulWidget {
  const UserSettingsBody({super.key});

  @override
  ConsumerState<UserSettingsBody> createState() => _UserSettingsBodyState();
}

class _UserSettingsBodyState extends ConsumerState<UserSettingsBody>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref.read(smsPermissionControllerProvider.notifier).refreshStatus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(smsPermissionControllerProvider.notifier).refreshStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (!next.isLoading && next.error != null) {
        AppSnackbar.show(
          context,
          message: next.error!.toLocalizedString(context),
          type: AppSnackbarType.error,
        );
        ref.read(authNotifierProvider.notifier).clearError();
        return;
      }

      final hasCompletedNameUpdate =
          previous?.loadingMethod == AuthLoadingMethod.confirmName &&
          next.loadingMethod == AuthLoadingMethod.none &&
          next.error == null;
      if (hasCompletedNameUpdate) {
        AppSnackbar.show(
          context,
          message: context.l10n.userSettingsNameUpdatedSuccess,
          type: AppSnackbarType.success,
        );
      }
    });

    ref.listen<SmsPermissionState>(smsPermissionControllerProvider, (
      previous,
      next,
    ) {
      if (next.error == null) {
        return;
      }

      AppSnackbar.show(
        context,
        message: next.error!.toLocalizedString(context),
        type: AppSnackbarType.error,
      );
      ref.read(smsPermissionControllerProvider.notifier).clearError();
    });

    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return const AppLoader();
    }

    final authState = ref.watch(authNotifierProvider);
    final smsPermissionState = ref.watch(smsPermissionControllerProvider);

    return SingleChildScrollView(
      padding: AppResponsive.symmetricPadding(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
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
          AppSpacing.xl.verticalSpace,
          SettingsSectionTitle(label: context.l10n.userSettingsAppSection),
          AppSpacing.sm.verticalSpace,
          SettingsSmsPermissionCard(
            state: smsPermissionState,
            onOpenSettings: ref
                .read(smsPermissionControllerProvider.notifier)
                .openSettings,
          ),
          AppSpacing.xl.verticalSpace,
          SettingsSectionTitle(label: context.l10n.userSettingsAccountSection),
          AppSpacing.sm.verticalSpace,
          SettingsAccountActions(
            isSigningOut: authState.loadingMethod == AuthLoadingMethod.signOut,
            onSignOut: () => _showSignOutDialog(context),
            onDeleteAccount: () => _showDeleteAccountConfirmDialog(context),
          ),
          AppSpacing.xl.verticalSpace,
          SettingsSectionTitle(label: context.l10n.userSettingsAboutSection),
          AppSpacing.sm.verticalSpace,
          const SettingsAppVersionCard(),
        ],
      ),
    );
  }

  Future<void> _showSignOutDialog(BuildContext context) {
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
