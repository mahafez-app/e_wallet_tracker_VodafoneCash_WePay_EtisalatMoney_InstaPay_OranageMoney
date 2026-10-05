import 'package:equatable/equatable.dart';
import 'package:wallet_product/wallet_product.dart';
import 'package:mahafez_core/mahafez_core.dart';
enum UserSettingsWalletsAction { none, deletingWallet }

class UserSettingsWalletsState extends Equatable {
  const UserSettingsWalletsState({
    this.wallets = const [],
    this.isLoading = false,
    this.action = UserSettingsWalletsAction.none,
    this.activeWalletId,
    this.error,
    this.successMessage,
  });

  final List<WalletEntity> wallets;
  final bool isLoading;
  final UserSettingsWalletsAction action;
  final String? activeWalletId;
  final Failure? error;
  final String? successMessage;

  static const _unset = Object();

  UserSettingsWalletsState copyWith({
    List<WalletEntity>? wallets,
    bool? isLoading,
    UserSettingsWalletsAction? action,
    Object? activeWalletId = _unset,
    Object? error = _unset,
    Object? successMessage = _unset,
  }) {
    return UserSettingsWalletsState(
      wallets: wallets ?? this.wallets,
      isLoading: isLoading ?? this.isLoading,
      action: action ?? this.action,
      activeWalletId: activeWalletId == _unset
          ? this.activeWalletId
          : activeWalletId as String?,
      error: error == _unset ? this.error : error as Failure?,
      successMessage: successMessage == _unset
          ? this.successMessage
          : successMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    wallets,
    isLoading,
    action,
    activeWalletId,
    error,
    successMessage,
  ];
}
