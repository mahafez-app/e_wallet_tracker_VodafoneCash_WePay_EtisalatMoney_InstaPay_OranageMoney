import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class PowerManagerService {
  Future<bool> isXiaomiDevice();
  Future<bool> isIgnoringBatteryOptimizations();
  Future<void> requestIgnoreBatteryOptimizations();
  Future<void> openAutostartSettings();
}

class PowerManagerServiceImpl implements PowerManagerService {
  final DeviceInfoPlugin _deviceInfo;

  PowerManagerServiceImpl(this._deviceInfo);

  @override
  Future<bool> isXiaomiDevice() async {
    if (!Platform.isAndroid) return false;
    final androidInfo = await _deviceInfo.androidInfo;
    final manufacturer = androidInfo.manufacturer.toLowerCase();
    return manufacturer == 'xiaomi' ||
        manufacturer == 'redmi' ||
        manufacturer == 'poco';
  }

  @override
  Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    return Permission.ignoreBatteryOptimizations.isGranted;
  }

  @override
  Future<void> requestIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return;
    await Permission.ignoreBatteryOptimizations.request();
  }

  @override
  Future<void> openAutostartSettings() async {
    // Standard android app settings is the safest fallback.
    await openAppSettings();
  }
}
