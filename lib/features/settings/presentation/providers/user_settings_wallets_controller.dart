import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wallets/providers/wallets_providers.dart';
import 'user_settings_wallets_state.dart';

final userSettingsWalletsControllerProvider = NotifierProvider.autoDispose<
  UserSettingsWalletsController,
  UserSettingsWalletsState
>(UserSettingsWalletsController.new);

class UserSettingsWalletsController
    extends Notifier<UserSettingsWalletsState> {
  @override
  UserSettingsWalletsState build() {
    _loadWallets();
    return const UserSettingsWalletsState(isLoading: true);
  }

  Future<void> _loadWallets() async {
    final result = await ref.read(getWalletsUseCaseProvider)();
    if (!ref.mounted) return;

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure),
      (wallets) => state = state.copyWith(isLoading: false, wallets: wallets),
    );
  }

  Future<void> deleteWallet(String walletId) async {
    state = state.copyWith(
      action: UserSettingsWalletsAction.deletingWallet,
      activeWalletId: walletId,
      error: null,
    );

    final result = await ref.read(deleteWalletUseCaseProvider)(walletId);
    if (!ref.mounted) return;

    result.fold(
      (failure) => state = state.copyWith(
        action: UserSettingsWalletsAction.none,
        activeWalletId: null,
        error: failure,
      ),
      (_) {
        state = state.copyWith(
          action: UserSettingsWalletsAction.none,
          activeWalletId: null,
          successMessage: 'Wallet deleted successfully', // Will be localized in UI or via state mapping
          wallets:
              state.wallets.where((wallet) => wallet.id != walletId).toList(),
        );
        // Also refresh other parts of the app if needed
        ref.invalidate(getWalletsUseCaseProvider);
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }
}
