import 'package:permission_handler/permission_handler.dart';

import '../../../../core/error/failures.dart';

abstract interface class SmsPermissionDataSource {
  Future<bool> requestPermission();

  Future<bool> hasPermission();

  Future<void> openSettings();
}

final class SmsPermissionDataSourceImpl implements SmsPermissionDataSource {
  const SmsPermissionDataSourceImpl();

  @override
  Future<bool> requestPermission() async {
    final statuses = await <Permission>[
      Permission.sms,
      Permission.phone,
    ].request();

    return _isGranted(statuses[Permission.sms]) &&
        _isGranted(statuses[Permission.phone]);
  }

  @override
  Future<bool> hasPermission() async {
    final smsPermissionStatus = await Permission.sms.status;
    final phonePermissionStatus = await Permission.phone.status;

    return _isGranted(smsPermissionStatus) && _isGranted(phonePermissionStatus);
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

  bool _isGranted(PermissionStatus? status) => status?.isGranted == true;
}
