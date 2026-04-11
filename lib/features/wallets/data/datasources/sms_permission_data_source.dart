import 'package:permission_handler/permission_handler.dart';

abstract interface class SmsPermissionDataSource {
  Future<bool> requestPermissions();
  Future<bool> hasPermissions();
}

class SmsPermissionDataSourceImpl implements SmsPermissionDataSource {
  const SmsPermissionDataSourceImpl();

  @override
  Future<bool> requestPermissions() async {
    final statuses = await <Permission>[
      Permission.sms,
      Permission.phone,
    ].request();

    return _isGranted(statuses[Permission.sms]) &&
        _isGranted(statuses[Permission.phone]);
  }

  @override
  Future<bool> hasPermissions() async {
    final smsPermissionStatus = await Permission.sms.status;
    final phonePermissionStatus = await Permission.phone.status;

    return _isGranted(smsPermissionStatus) && _isGranted(phonePermissionStatus);
  }

  bool _isGranted(PermissionStatus? status) => status?.isGranted == true;
}
