import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/service_providers.dart';
import '../../domain/usecases/add_wallets_usecase.dart';
import '../../providers/wallets_providers.dart';

final class AddWalletState {
  final String phoneNumber;
  final Set<WalletProvider> selectedProviders;

  const AddWalletState({
    required this.phoneNumber,
    required this.selectedProviders,
  });

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
  AddWalletState build() {
    return const AddWalletState(phoneNumber: '', selectedProviders: {});
  }

  void updatePhoneNumber(String newNumber) {
    Set<WalletProvider> newProviders = Set.of(state.selectedProviders);

    // Auto-select provider based on prefix if starting fresh or if it's a new clear prefix typing
    if (newNumber.length >= 3) {
      final prefix = newNumber.substring(0, 3);
      if (prefix == '010') {
        newProviders.add(WalletProvider.vodafoneCash);
      } else if (prefix == '011') {
        newProviders.add(WalletProvider.etisalatCash);
      } else if (prefix == '012') {
        newProviders.add(WalletProvider.orangeMoney);
      } else if (prefix == '015') {
        newProviders.add(WalletProvider.wePay);
      }
    } else {
      newProviders.clear();
    }

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
}

final addWalletSubmitProvider =
    AsyncNotifierProvider.autoDispose<AddWalletSubmitController, void>(
      AddWalletSubmitController.new,
    );

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

    final addUseCase = ref.read(addWalletsUseCaseProvider);
    final params = AddWalletsParams(
      phoneNumber: walletState.phoneNumber,
      providers: walletState.selectedProviders.map((e) => e.toValue).toList(),
      deviceId: '$deviceName ($deviceId)',
    );

    final result = await addUseCase(params);
    result.fold((failure) => state = AsyncError(failure, StackTrace.current), (
      _,
    ) {
      state = const AsyncData(null);
      ref.read(addWalletControllerProvider.notifier).reset();
    });
  }
}
