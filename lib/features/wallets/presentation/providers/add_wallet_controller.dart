import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/service_providers.dart';
import '../../domain/usecases/add_wallets_usecase.dart';
import '../../providers/wallets_providers.dart';

// ── Form state ──────────────────────────────────────────────────────────────

final class AddWalletState {
  const AddWalletState({
    required this.devicePhoneNumbers,
    required this.phoneNumber,
    required this.selectedProviders,
  });

  final List<String> devicePhoneNumbers;
  final String phoneNumber;
  final Set<WalletProvider> selectedProviders;

  AddWalletState copyWith({
    List<String>? devicePhoneNumbers,
    String? phoneNumber,
    Set<WalletProvider>? selectedProviders,
  }) {
    return AddWalletState(
      devicePhoneNumbers: devicePhoneNumbers ?? this.devicePhoneNumbers,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedProviders: selectedProviders ?? this.selectedProviders,
    );
  }
}

final addWalletControllerProvider =
    AsyncNotifierProvider.autoDispose<AddWalletController, AddWalletState>(
  AddWalletController.new,
);

class AddWalletController extends AsyncNotifier<AddWalletState> {
  @override
  FutureOr<AddWalletState> build() async {
    final phoneNumberService = ref.watch(phoneNumberServiceProvider);
    final numbers = await phoneNumberService.getDevicePhoneNumbers();

    var initialNumber = '';
    var initialProviders = const <WalletProvider>{};

    if (numbers.isNotEmpty) {
      initialNumber = numbers.first;
      initialProviders = _autoSelectProvider(initialNumber, {});
    }

    return AddWalletState(
      devicePhoneNumbers: numbers,
      phoneNumber: initialNumber,
      selectedProviders: initialProviders,
    );
  }

  void updatePhoneNumber(String newNumber) {
    if (!state.hasValue) return;

    final currentState = state.value!;
    final newProviders = _autoSelectProvider(
      newNumber,
      currentState.selectedProviders,
    );
    state = AsyncData(
      currentState.copyWith(
        phoneNumber: newNumber,
        selectedProviders: newProviders,
      ),
    );
  }

  void toggleProvider(WalletProvider provider) {
    if (!state.hasValue) return;

    final currentState = state.value!;
    final currentProviders = Set<WalletProvider>.of(
      currentState.selectedProviders,
    );
    if (currentProviders.contains(provider)) {
      currentProviders.remove(provider);
    } else {
      currentProviders.add(provider);
    }
    state = AsyncData(
      currentState.copyWith(selectedProviders: currentProviders),
    );
  }

  void reset() {
    if (!state.hasValue) return;

    final currentState = state.value!;
    var initialNumber = '';
    var initialProviders = const <WalletProvider>{};

    if (currentState.devicePhoneNumbers.isNotEmpty) {
      initialNumber = currentState.devicePhoneNumbers.first;
      initialProviders = _autoSelectProvider(initialNumber, {});
    }

    state = AsyncData(
      currentState.copyWith(
        phoneNumber: initialNumber,
        selectedProviders: initialProviders,
      ),
    );
  }

  Set<WalletProvider> _autoSelectProvider(
    String number,
    Set<WalletProvider> currentProviders,
  ) {
    if (number.length < 3) return currentProviders;
    final prefix = number.substring(0, 3);
    return switch (prefix) {
      '010' => {WalletProvider.vodafoneCash},
      '011' => {WalletProvider.etisalatCash},
      '012' => {WalletProvider.orangeMoney},
      '015' => {WalletProvider.wePay},
      _ => Set.of(currentProviders),
    };
  }
}

// ── Submit controller ───────────────────────────────────────────────────────

final addWalletSubmitProvider =
    AsyncNotifierProvider.autoDispose<AddWalletSubmitController, void>(
  AddWalletSubmitController.new,
);

class AddWalletSubmitController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit() async {
    state = const AsyncLoading();

    final walletStateAsync = ref.read(addWalletControllerProvider);
    if (!walletStateAsync.hasValue) {
      state = AsyncError(
        const ValidationFailure(code: 'wallet-state-unavailable'),
        StackTrace.current,
      );
      return;
    }

    final walletState = walletStateAsync.value!;

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
