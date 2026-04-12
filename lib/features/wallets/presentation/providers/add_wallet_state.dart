import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/egyptian_phone_number.dart';

const unsetFailure = Object();

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

  bool get hasValidPhoneNumber =>
      EgyptianPhoneNumber.isValidMobileNumber(phoneNumber);

  Set<WalletProvider> get allowedProviders =>
      EgyptianPhoneNumber.allowedProviders(phoneNumber);

  AddWalletState copyWith({
    List<String>? devicePhoneNumbers,
    String? phoneNumber,
    Set<WalletProvider>? selectedProviders,
    bool? isLoadingDevicePhoneNumbers,
    Object? loadFailure = unsetFailure,
    AddWalletSubmissionStatus? submissionStatus,
    Object? submissionFailure = unsetFailure,
  }) {
    return AddWalletState(
      devicePhoneNumbers: devicePhoneNumbers ?? this.devicePhoneNumbers,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedProviders: selectedProviders ?? this.selectedProviders,
      isLoadingDevicePhoneNumbers:
          isLoadingDevicePhoneNumbers ?? this.isLoadingDevicePhoneNumbers,
      loadFailure: identical(loadFailure, unsetFailure)
          ? this.loadFailure
          : loadFailure as Failure?,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submissionFailure: identical(submissionFailure, unsetFailure)
          ? this.submissionFailure
          : submissionFailure as Failure?,
    );
  }
}
