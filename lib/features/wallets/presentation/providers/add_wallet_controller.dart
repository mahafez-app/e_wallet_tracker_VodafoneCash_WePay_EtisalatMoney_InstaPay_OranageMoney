import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/service_providers.dart';
import '../../domain/usecases/add_wallets_usecase.dart';
import '../../providers/wallets_providers.dart';

// ── Form state ──────────────────────────────────────────────────────────────

final class AddWalletState {
  const AddWalletState({
    required this.phoneNumber,
    required this.selectedProviders,
  });

  final String phoneNumber;
  final Set<WalletProvider> selectedProviders;

  AddWalletState copyWith({
    String? phoneNumber,
    Set<WalletProvider>? selectedProviders,
  }) {
    return AddWalletState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedProviders: selectedProviders ?? this.selectedProviders,
    );
  }
}

final addWalletControllerProvider =
    NotifierProvider.autoDispose<AddWalletController, AddWalletState>(
      AddWalletController.new,
    );

class AddWalletController extends Notifier<AddWalletState> {
  @override
  AddWalletState build() =>
      const AddWalletState(phoneNumber: '', selectedProviders: {});

  void updatePhoneNumber(String newNumber) {
    final newProviders = _autoSelectProvider(newNumber);
    state = state.copyWith(
      phoneNumber: newNumber,
      selectedProviders: newProviders,
    );
  }

  void toggleProvider(WalletProvider provider) {
    final current = Set<WalletProvider>.of(state.selectedProviders);
    if (current.contains(provider)) {
      current.remove(provider);
    } else {
      current.add(provider);
    }
    state = state.copyWith(selectedProviders: current);
  }

  void reset() {
    state = const AddWalletState(phoneNumber: '', selectedProviders: {});
  }

  Set<WalletProvider> _autoSelectProvider(String number) {
    if (number.length < 3) return {};
    final prefix = number.substring(0, 3);
    return switch (prefix) {
      '010' => {WalletProvider.vodafoneCash},
      '011' => {WalletProvider.etisalatCash},
      '012' => {WalletProvider.orangeMoney},
      '015' => {WalletProvider.wePay},
      _ => Set.of(state.selectedProviders),
    };
  }
}

// ── Submit controller ───────────────────────────────────────────────────────

final addWalletSubmitProvider =
    AsyncNotifierProvider.autoDispose<AddWalletSubmitController, void>(
      AddWalletSubmitController.new,
    );

/// Handles the wallet creation flow.
/// On success, transitions to [AsyncData]. Navigation is driven by the
/// widget's [ref.listen] — specifically checking SMS permission and routing
/// accordingly.
class AddWalletSubmitController extends AsyncNotifier<void> {
  @override
  void build() {}

  Future<void> submit() async {
    state = const AsyncLoading();

    final walletState = ref.read(addWalletControllerProvider);

    if (walletState.phoneNumber.isEmpty) {
      state = AsyncError(
        const ValidationFailure(code: 'wallet-phone-required'),
        StackTrace.current,
      );
      return;
    }

    if (walletState.selectedProviders.isEmpty) {
      state = AsyncError(
        const ValidationFailure(code: 'wallet-provider-required'),
        StackTrace.current,
      );
      return;
    }

    final deviceInfoService = ref.read(deviceInfoServiceProvider);
    final deviceId = await deviceInfoService.getDeviceId();
    final deviceName = await deviceInfoService.getDeviceName();

    final result = await ref.read(addWalletsUseCaseProvider)(
      AddWalletsParams(
        phoneNumber: walletState.phoneNumber,
        providers: walletState.selectedProviders.map((e) => e.toValue).toList(),
        deviceId: '$deviceName ($deviceId)',
      ),
    );

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) {
        ref.read(addWalletControllerProvider.notifier).reset();
        state = const AsyncData(null);
      },
    );
  }
}
