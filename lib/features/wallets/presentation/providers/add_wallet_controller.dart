import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/add_wallets_usecase.dart';
import '../../providers/wallets_providers.dart';

const _unsetFailure = Object();

enum AddWalletSubmissionStatus { idle, loading, success, failure }

final class AddWalletState {
  const AddWalletState({
    required this.devicePhoneNumbers,
    required this.phoneNumber,
    required this.selectedProviders,
    required this.isLoadingDevicePhoneNumbers,
    required this.loadFailure,
    required this.submissionStatus,
    required this.submissionFailure,
  });

  const AddWalletState.initial()
    : devicePhoneNumbers = const <String>[],
      phoneNumber = '',
      selectedProviders = const <WalletProvider>{},
      isLoadingDevicePhoneNumbers = true,
      loadFailure = null,
      submissionStatus = AddWalletSubmissionStatus.idle,
      submissionFailure = null;

  final List<String> devicePhoneNumbers;
  final String phoneNumber;
  final Set<WalletProvider> selectedProviders;
  final bool isLoadingDevicePhoneNumbers;
  final Failure? loadFailure;
  final AddWalletSubmissionStatus submissionStatus;
  final Failure? submissionFailure;

  bool get isSubmitting =>
      submissionStatus == AddWalletSubmissionStatus.loading;

  AddWalletState copyWith({
    List<String>? devicePhoneNumbers,
    String? phoneNumber,
    Set<WalletProvider>? selectedProviders,
    bool? isLoadingDevicePhoneNumbers,
    Object? loadFailure = _unsetFailure,
    AddWalletSubmissionStatus? submissionStatus,
    Object? submissionFailure = _unsetFailure,
  }) {
    return AddWalletState(
      devicePhoneNumbers: devicePhoneNumbers ?? this.devicePhoneNumbers,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedProviders: selectedProviders ?? this.selectedProviders,
      isLoadingDevicePhoneNumbers:
          isLoadingDevicePhoneNumbers ?? this.isLoadingDevicePhoneNumbers,
      loadFailure: identical(loadFailure, _unsetFailure)
          ? this.loadFailure
          : loadFailure as Failure?,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submissionFailure: identical(submissionFailure, _unsetFailure)
          ? this.submissionFailure
          : submissionFailure as Failure?,
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
    unawaited(_loadDevicePhoneNumbers());
    return const AddWalletState.initial();
  }

  void updatePhoneNumber(String phoneNumber) {
    final trimmedPhoneNumber = phoneNumber.trim();
    state = state.copyWith(
      phoneNumber: trimmedPhoneNumber,
      selectedProviders: _autoSelectProvider(
        trimmedPhoneNumber,
        state.selectedProviders,
      ),
      submissionStatus: AddWalletSubmissionStatus.idle,
      submissionFailure: null,
    );
  }

  void toggleProvider(WalletProvider provider) {
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
    final selectedProviders = _resolveInitialProviders(initialPhoneNumber);

    state = state.copyWith(
      devicePhoneNumbers: phoneNumbers,
      phoneNumber: initialPhoneNumber,
      selectedProviders: selectedProviders,
      isLoadingDevicePhoneNumbers: false,
      loadFailure: null,
    );
  }

  String _resolveInitialPhoneNumber(List<String> phoneNumbers) {
    if (state.phoneNumber.isNotEmpty) return state.phoneNumber;
    if (phoneNumbers.isEmpty) return '';

    return phoneNumbers.first;
  }

  Set<WalletProvider> _resolveInitialProviders(String phoneNumber) {
    if (state.selectedProviders.isNotEmpty) return state.selectedProviders;
    return _autoSelectProvider(phoneNumber, const <WalletProvider>{});
  }

  Failure? _validate(AddWalletState currentState) {
    if (currentState.phoneNumber.isEmpty) {
      return const ValidationFailure(code: 'wallet-phone-required');
    }

    if (currentState.selectedProviders.isEmpty) {
      return const ValidationFailure(code: 'wallet-provider-required');
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
    final selectedProviders = _autoSelectProvider(
      initialPhoneNumber,
      const <WalletProvider>{},
    );

    state = state.copyWith(
      phoneNumber: initialPhoneNumber,
      selectedProviders: selectedProviders,
      submissionStatus: AddWalletSubmissionStatus.success,
      submissionFailure: null,
    );
  }

  Set<WalletProvider> _autoSelectProvider(
    String phoneNumber,
    Set<WalletProvider> currentProviders,
  ) {
    final normalizedPhoneNumber = _normalizePhoneNumber(phoneNumber);
    if (normalizedPhoneNumber.length < 3) return currentProviders;

    final prefix = normalizedPhoneNumber.substring(0, 3);
    return switch (prefix) {
      '010' => {WalletProvider.vodafoneCash},
      '011' => {WalletProvider.etisalatCash},
      '012' => {WalletProvider.orangeMoney},
      '015' => {WalletProvider.wePay},
      _ => currentProviders,
    };
  }

  String _normalizePhoneNumber(String phoneNumber) {
    var normalizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (normalizedPhoneNumber.startsWith('+20')) {
      return '0${normalizedPhoneNumber.substring(3)}';
    }

    if (normalizedPhoneNumber.startsWith('20') &&
        normalizedPhoneNumber.length == 12) {
      return '0${normalizedPhoneNumber.substring(2)}';
    }

    return normalizedPhoneNumber;
  }
}
