import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/egyptian_phone_number.dart';
import '../../domain/usecases/add_wallets_usecase.dart';
import '../../providers/wallets_providers.dart';
import 'add_wallet_state.dart';

final addWalletControllerProvider =
    NotifierProvider.autoDispose<AddWalletController, AddWalletState>(
      AddWalletController.new,
    );

class AddWalletController extends Notifier<AddWalletState> {
  @override
  AddWalletState build() {
    unawaited(_loadDevicePhoneNumbers());
    return const AddWalletState.initial();
  }

  void updatePhoneNumber(String phoneNumber) {
    final normalizedPhoneNumber = EgyptianPhoneNumber.normalize(phoneNumber);
    state = state.copyWith(
      phoneNumber: normalizedPhoneNumber,
      selectedProviders: _resolveSelectedProviders(
        phoneNumber: normalizedPhoneNumber,
        currentProviders: state.selectedProviders,
      ),
      submissionStatus: AddWalletSubmissionStatus.idle,
      submissionFailure: null,
    );
  }

  void toggleProvider(WalletProvider provider) {
    if (!state.allowedProviders.contains(provider)) return;

    final selectedProviders = Set<WalletProvider>.of(state.selectedProviders);
    if (selectedProviders.contains(provider)) {
      selectedProviders.remove(provider);
    } else {
      selectedProviders.add(provider);
    }

    state = state.copyWith(
      selectedProviders: selectedProviders,
      submissionStatus: AddWalletSubmissionStatus.idle,
      submissionFailure: null,
    );
  }

  void submit() {
    final validationFailure = _validate(state);
    if (validationFailure != null) {
      _setSubmissionFailure(validationFailure);
      return;
    }

    final currentState = state;
    state = state.copyWith(
      submissionStatus: AddWalletSubmissionStatus.loading,
      submissionFailure: null,
    );
    unawaited(_submitValidated(currentState));
  }

  Future<void> _loadDevicePhoneNumbers() async {
    final result = await ref.read(getDevicePhoneNumbersUseCaseProvider)();
    if (!ref.mounted) return;

    result.fold(_setLoadFailure, _applyLoadedPhoneNumbers);
  }

  void _setLoadFailure(Failure failure) {
    state = state.copyWith(
      isLoadingDevicePhoneNumbers: false,
      loadFailure: failure,
    );
  }

  void _applyLoadedPhoneNumbers(List<String> phoneNumbers) {
    final initialPhoneNumber = _resolveInitialPhoneNumber(phoneNumbers);

    state = state.copyWith(
      devicePhoneNumbers: phoneNumbers,
      phoneNumber: initialPhoneNumber,
      selectedProviders: _resolveSelectedProviders(
        phoneNumber: initialPhoneNumber,
        currentProviders: state.selectedProviders,
      ),
      isLoadingDevicePhoneNumbers: false,
      loadFailure: null,
    );
  }

  String _resolveInitialPhoneNumber(List<String> phoneNumbers) {
    if (state.phoneNumber.isNotEmpty) {
      return EgyptianPhoneNumber.normalize(state.phoneNumber);
    }

    if (phoneNumbers.isEmpty) return '';

    return EgyptianPhoneNumber.normalize(phoneNumbers.first);
  }

  Failure? _validate(AddWalletState currentState) {
    if (currentState.phoneNumber.isEmpty) {
      return const ValidationFailure(code: 'wallet-phone-required');
    }

    if (!currentState.hasValidPhoneNumber) {
      return const ValidationFailure(code: 'wallet-phone-invalid');
    }

    if (currentState.selectedProviders.isEmpty) {
      return const ValidationFailure(code: 'wallet-provider-required');
    }

    if (!currentState.allowedProviders.containsAll(
      currentState.selectedProviders,
    )) {
      return const ValidationFailure(code: 'wallet-provider-mismatch');
    }

    return null;
  }

  void _setSubmissionFailure(Failure failure) {
    state = state.copyWith(
      submissionStatus: AddWalletSubmissionStatus.failure,
      submissionFailure: failure,
    );
  }

  Future<void> _submitValidated(AddWalletState currentState) async {
    final result = await ref.read(addWalletsUseCaseProvider)(
      AddWalletsParams(
        phoneNumber: currentState.phoneNumber,
        providers: currentState.selectedProviders
            .map((provider) => provider.toValue)
            .toList(),
      ),
    );

    if (!ref.mounted) return;

    result.fold(_setSubmissionFailure, (_) => _setSubmissionSuccess());
  }

  void _setSubmissionSuccess() {
    final initialPhoneNumber = _resolveInitialPhoneNumber(
      state.devicePhoneNumbers,
    );

    state = state.copyWith(
      phoneNumber: initialPhoneNumber,
      selectedProviders: _resolveSelectedProviders(
        phoneNumber: initialPhoneNumber,
        currentProviders: const <WalletProvider>{},
      ),
      submissionStatus: AddWalletSubmissionStatus.success,
      submissionFailure: null,
    );
  }

  Set<WalletProvider> _resolveSelectedProviders({
    required String phoneNumber,
    Set<WalletProvider> currentProviders = const <WalletProvider>{},
  }) {
    final allowedProviders = EgyptianPhoneNumber.allowedProviders(phoneNumber);
    if (allowedProviders.isEmpty) return const <WalletProvider>{};

    final selectedProviders = currentProviders
        .where(allowedProviders.contains)
        .toSet();
    if (selectedProviders.isNotEmpty) return selectedProviders;

    final primaryProvider = EgyptianPhoneNumber.primaryProvider(phoneNumber);
    if (primaryProvider == null) return const <WalletProvider>{};

    return {primaryProvider};
  }
}
