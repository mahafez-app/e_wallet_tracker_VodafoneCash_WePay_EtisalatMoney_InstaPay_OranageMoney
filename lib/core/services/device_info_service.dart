import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

abstract interface class DeviceInfoService {
  Future<String> getDeviceId();
  Future<String> getDeviceName();
}

class DeviceInfoServiceImpl implements DeviceInfoService {
  const DeviceInfoServiceImpl(this._deviceInfoPlugin);

  final DeviceInfoPlugin _deviceInfoPlugin;

  @override
  Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown_ios_id';
    }
    return 'unknown_device_id';
  }

  @override
  Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return '${androidInfo.manufacturer} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.name;
    }
    return 'unknown_device_name';
  }
}
