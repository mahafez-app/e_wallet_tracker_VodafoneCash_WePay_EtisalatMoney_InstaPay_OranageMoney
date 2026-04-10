import 'package:another_telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class SmsPermissionDataSource {
  Future<bool?> requestSmsPermission();
  Future<bool> hasSmsPermission();
}

class SmsPermissionDataSourceImpl implements SmsPermissionDataSource {
  const SmsPermissionDataSourceImpl();

  @override
  Future<bool?> requestSmsPermission() {
    return Telephony.instance.requestPhoneAndSmsPermissions;
  }

  @override
  Future<bool> hasSmsPermission() async {
    final smsPermissionsStatus = await Permission.sms.status;
    final phonePermissionsStatus = await Permission.phone.status;

    return smsPermissionsStatus.isGranted && phonePermissionsStatus.isGranted;
  }
}
