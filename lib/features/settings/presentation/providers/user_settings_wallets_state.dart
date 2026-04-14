import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/error/failures.dart';

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

  UserSettingsWalletsState copyWith({
    List<WalletEntity>? wallets,
    bool? isLoading,
    UserSettingsWalletsAction? action,
    String? activeWalletId,
    Failure? error,
    String? successMessage,
  }) {
    return UserSettingsWalletsState(
      wallets: wallets ?? this.wallets,
      isLoading: isLoading ?? this.isLoading,
      action: action ?? this.action,
      activeWalletId: activeWalletId ?? this.activeWalletId,
      error: error,
      successMessage: successMessage,
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
