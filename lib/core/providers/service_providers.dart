import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/device_info_service.dart';


final deviceInfoPluginProvider = Provider<DeviceInfoPlugin>(
  (_) => DeviceInfoPlugin(),
);

final deviceInfoServiceProvider = Provider<DeviceInfoService>(
  (ref) => DeviceInfoServiceImpl(ref.watch(deviceInfoPluginProvider)),
);


