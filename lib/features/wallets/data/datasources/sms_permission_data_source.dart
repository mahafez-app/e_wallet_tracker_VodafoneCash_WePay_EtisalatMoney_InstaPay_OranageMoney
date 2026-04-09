import 'package:permission_handler/permission_handler.dart';

abstract interface class SmsPermissionDataSource {
  Future<bool> requestSmsPermission();
  Future<bool> hasSmsPermission();
}

class SmsPermissionDataSourceImpl implements SmsPermissionDataSource {
  const SmsPermissionDataSourceImpl();

  @override
  Future<bool> requestSmsPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  @override
  Future<bool> hasSmsPermission() async {
    final status = await Permission.sms.status;
    return status.isGranted;
  }
}
