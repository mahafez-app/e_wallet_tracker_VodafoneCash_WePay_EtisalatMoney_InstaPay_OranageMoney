// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../providers/app_preferences_controller.dart';
import '../providers/app_preferences_state.dart';
import '../providers/sms_permission_controller.dart';
import '../providers/user_settings_wallets_controller.dart';
import '../providers/user_settings_wallets_state.dart';

class UserSettingsFeedbackListeners extends StatelessWidget {
  const UserSettingsFeedbackListeners({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _AuthFeedbackListener(
      child: _SmsPermissionFeedbackListener(
        child: _AppPreferencesFeedbackListener(
          child: _UserSettingsWalletsFeedbackListener(child: child),
        ),
      ),
    );
  }
}

class _AuthFeedbackListener extends ConsumerWidget {
  const _AuthFeedbackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authNotifierProvider.notifier);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (!next.isLoading && next.error != null) {
        MahafezSnackbar.showFailure(context, failure: next.error!);
        authController.clearError();
        return;
      }

      final hasCompletedNameUpdate =
          previous?.loadingMethod == AuthLoadingMethod.confirmName &&
          next.loadingMethod == AuthLoadingMethod.none &&
          next.error == null;
      if (hasCompletedNameUpdate) {
        MahafezSnackbar.show(
          context,
          message: context.l10n.userSettingsNameUpdatedSuccess,
          type: MahafezSnackbarType.success,
        );
      }
    });

    return child;
  }
}

class _SmsPermissionFeedbackListener extends ConsumerWidget {
  const _SmsPermissionFeedbackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smsPermissionController = ref.read(
      smsPermissionControllerProvider.notifier,
    );

    ref.listen<SmsPermissionState>(smsPermissionControllerProvider, (
      previous,
      next,
    ) {
      if (next.error == null) return;
      MahafezSnackbar.showFailure(context, failure: next.error!);
      smsPermissionController.clearError();
    });

    return child;
  }
}

class _AppPreferencesFeedbackListener extends ConsumerWidget {
  const _AppPreferencesFeedbackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appPreferencesController = ref.read(
      appPreferencesControllerProvider.notifier,
    );

    ref.listen<AppPreferencesState>(appPreferencesControllerProvider, (
      previous,
      next,
    ) {
      if (next.failure == null) return;
      MahafezSnackbar.showFailure(context, failure: next.failure!);
      appPreferencesController.clearError();
    });

    return child;
  }
}

class _UserSettingsWalletsFeedbackListener extends ConsumerWidget {
  const _UserSettingsWalletsFeedbackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(userSettingsWalletsControllerProvider.notifier);

    ref.listen<UserSettingsWalletsState>(userSettingsWalletsControllerProvider, (
      previous,
      next,
    ) {
      if (next.error != null) {
        MahafezSnackbar.showFailure(context, failure: next.error!);
        controller.clearError();
        return;
      }

      if (next.successMessage != null) {
        MahafezSnackbar.show(
          context,
          message: context.l10n.userSettingsWalletDeletedSuccess,
          type: MahafezSnackbarType.success,
        );
        controller.clearSuccessMessage();
      }
    });

    return child;
  }
}
