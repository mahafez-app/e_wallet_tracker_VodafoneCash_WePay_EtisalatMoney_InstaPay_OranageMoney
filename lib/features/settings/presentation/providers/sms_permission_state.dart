import 'package:mahafez_core/mahafez_core.dart';
const unsetSmsPermissionFailure = Object();

final class SmsPermissionState {
  const SmsPermissionState({
    this.hasPermission = false,
    this.isChecking = false,
    this.isRequesting = false,
    this.isOpeningSettings = false,
    this.error,
  });

  final bool hasPermission;
  final bool isChecking;
  final bool isRequesting;
  final bool isOpeningSettings;
  final Failure? error;

  SmsPermissionState copyWith({
    bool? hasPermission,
    bool? isChecking,
    bool? isRequesting,
    bool? isOpeningSettings,
    Object? error = unsetSmsPermissionFailure,
  }) {
    return SmsPermissionState(
      hasPermission: hasPermission ?? this.hasPermission,
      isChecking: isChecking ?? this.isChecking,
      isRequesting: isRequesting ?? this.isRequesting,
      isOpeningSettings: isOpeningSettings ?? this.isOpeningSettings,
      error: identical(error, unsetSmsPermissionFailure)
          ? this.error
          : error as Failure?,
    );
  }

  SmsPermissionState clearError() => copyWith(error: null);
}
