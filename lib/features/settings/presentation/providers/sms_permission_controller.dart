import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/sms_providers.dart';
import '../../providers/settings_providers.dart';
import 'sms_permission_state.dart';

export 'sms_permission_state.dart';

final hasPromptedSmsPermissionSessionProvider = StateProvider<bool>(
  (_) => false,
);

final smsPermissionControllerProvider =
    NotifierProvider.autoDispose<SmsPermissionController, SmsPermissionState>(
      SmsPermissionController.new,
    );

final class SmsPermissionController extends Notifier<SmsPermissionState> {
  @override
  SmsPermissionState build() => const SmsPermissionState();

  void clearError() {
    state = state.clearError();
  }

  void refreshStatus() {
    unawaited(_refreshStatus());
  }

  void requestPermission() {
    unawaited(_requestPermission());
  }

  void openSettings() {
    unawaited(_openSettings());
  }

  void checkAndPromptIfNeeded({
    required bool hasWallets,
    required VoidCallback navigateToPermission,
  }) {
    unawaited(
      _checkAndPromptIfNeeded(
        hasWallets: hasWallets,
        navigateToPermission: navigateToPermission,
      ),
    );
  }

  void handleWalletSetupFlow({
    required VoidCallback navigateHome,
    required VoidCallback navigateToPermission,
  }) {
    unawaited(
      _handleWalletSetupFlow(
        navigateHome: navigateHome,
        navigateToPermission: navigateToPermission,
      ),
    );
  }

  Future<void> _refreshStatus() async {
    state = state.copyWith(isChecking: true, error: null);

    final result = await ref.read(checkSmsPermissionUseCaseProvider)();
    if (!ref.mounted) {
      return;
    }

    result.fold(
      (failure) => state = state.copyWith(isChecking: false, error: failure),
      (hasPermission) {
        state = state.copyWith(
          hasPermission: hasPermission,
          isChecking: false,
          error: null,
        );
        _syncSmsReadiness(hasPermission);
      },
    );
  }

  Future<void> _requestPermission() async {
    state = state.copyWith(isRequesting: true, error: null);

    final result = await ref.read(requestSmsPermissionUseCaseProvider)();
    if (!ref.mounted) {
      return;
    }

    result.fold(
      (failure) => state = state.copyWith(isRequesting: false, error: failure),
      (hasPermission) {
        state = state.copyWith(
          hasPermission: hasPermission,
          isRequesting: false,
          error: null,
        );
        _syncSmsReadiness(hasPermission);
      },
    );
  }

  Future<void> _openSettings() async {
    state = state.copyWith(isOpeningSettings: true, error: null);

    final result = await ref.read(openSmsPermissionSettingsUseCaseProvider)();
    if (!ref.mounted) {
      return;
    }

    result.fold(
      (failure) =>
          state = state.copyWith(isOpeningSettings: false, error: failure),
      (_) => state = state.copyWith(isOpeningSettings: false, error: null),
    );
  }

  Future<void> _checkAndPromptIfNeeded({
    required bool hasWallets,
    required VoidCallback navigateToPermission,
  }) async {
    if (!hasWallets) {
      return;
    }

    final hasPrompted = ref.read(hasPromptedSmsPermissionSessionProvider);
    if (hasPrompted) {
      return;
    }

    ref.read(hasPromptedSmsPermissionSessionProvider.notifier).state = true;

    final result = await ref.read(checkSmsPermissionUseCaseProvider)();
    if (!ref.mounted) {
      return;
    }

    result.fold((failure) => state = state.copyWith(error: failure), (
      hasPermission,
    ) {
      state = state.copyWith(hasPermission: hasPermission, error: null);
      if (!hasPermission) {
        navigateToPermission();
      }
    });
  }

  Future<void> _handleWalletSetupFlow({
    required VoidCallback navigateHome,
    required VoidCallback navigateToPermission,
  }) async {
    final result = await ref.read(checkSmsPermissionUseCaseProvider)();
    if (!ref.mounted) {
      return;
    }

    result.fold((failure) => state = state.copyWith(error: failure), (
      hasPermission,
    ) {
      state = state.copyWith(hasPermission: hasPermission, error: null);
      if (hasPermission) {
        navigateHome();
        return;
      }

      ref.read(hasPromptedSmsPermissionSessionProvider.notifier).state = true;
      navigateToPermission();
    });
  }

  void _syncSmsReadiness(bool hasPermission) {
    if (hasPermission) {
      ref.invalidate(smsReadinessProvider);
    }
  }
}
