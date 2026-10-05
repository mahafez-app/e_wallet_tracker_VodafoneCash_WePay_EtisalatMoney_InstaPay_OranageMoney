import 'package:permission_handler/permission_handler.dart';

import 'package:mahafez_core/mahafez_core.dart';
abstract interface class SmsPermissionDataSource {
  Future<bool> requestPermission();

  Future<bool> hasPermission();

  Future<void> openSettings();
}

final class SmsPermissionDataSourceImpl implements SmsPermissionDataSource {
  const SmsPermissionDataSourceImpl();

  @override
  Future<bool> requestPermission() async {
    final smsPermissionStatus = await _requestIfNeeded(Permission.sms);
    return _isGranted(smsPermissionStatus);
  }

  @override
  Future<bool> hasPermission() async {
    final smsPermissionStatus = await Permission.sms.status;
    return _isGranted(smsPermissionStatus);
  }

  @override
  Future<void> openSettings() async {
    final isOpened = await openAppSettings();
    if (!isOpened) {
      throw const PermissionFailure(
        technicalMessage: 'Unable to open the app settings screen.',
      );
    }
  }

  Future<PermissionStatus> _requestIfNeeded(Permission permission) async {
    final currentStatus = await permission.status;
    if (_isGranted(currentStatus)) {
      return currentStatus;
    }

    return permission.request();
  }

  bool _isGranted(PermissionStatus? status) => status?.isGranted == true;
}
