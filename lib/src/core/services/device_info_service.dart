// device_info_service
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
// import 'package:device_info_plus/disable_battery_optimizations_latest.dart' show DisableBatteryOptimizationLatest;
// import 'package:disable_battery_optimization/disable_battery_optimization.dart';
// import 'package:mobile_device_identifier/mobile_device_identifier.dart';
// ignore: library_prefixes
import 'package:package_info_plus/package_info_plus.dart' as packageInfop;

import '../utils/app_logger.dart';
import 'service_interface.dart';

class DeviceInfoService implements ServiceInterface {
  late DeviceInfoPlugin _deviceInfo;
  DeviceInfoPlugin get deviceInfo => _deviceInfo;
  bool? isBatteryOptimizationDisabled;

  String? _device;
  String? _version;
  String? get version => _version;
  String? _deviceId;
  String? get deviceName => _device;
  String? get deviceId => _deviceId;
  @override
  Future initializeService() async {
    _deviceInfo = DeviceInfoPlugin();
    await _getDeviceName();
    _deviceId = await getDeviceIdDeviceInfoPlugin();
    AppLogger.logDebug('_deviceId :getDeviceIdDeviceInfoPlugin  $_deviceId');
    
    
    AppLogger.logDebug('_deviceId :getDeviceId  $_deviceId');
    AppLogger.logDebug('$name Success initialization');
    AppLogger.logDebug('_device  $_device');
    _version = await getVersion();
    AppLogger.logDebug('_version  $_version');
    // await getBatteryOptimizationState();
  
  }

  @override
String get name => "Device Info Service";

  _getDeviceName() async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _device = iosInfo.model;
    }
  }

 /*  Future<void> getBatteryOptimizationState() async {
    isBatteryOptimizationDisabled = await  DisableBatteryOptimizationLatest.isAllBatteryOptimizationDisabled;
    AppLogger.logInfo("isBetteryOptimizationDisabled $isBatteryOptimizationDisabled");
  }
 */
  // Singleton
  DeviceInfoService.int() {
    initializeService();
  }
  static DeviceInfoService? _instance;
  factory DeviceInfoService._() => _instance ??= DeviceInfoService.int();
  static DeviceInfoService get instance => DeviceInfoService._();

  Future<String?> getDeviceIdDeviceInfoPlugin() async {
    var deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id; // unique ID on Android
    } else {
      // return null;
    }
    AppLogger.logInfo(" Device Id: $deviceId");
    return deviceId;
  }

  

  Future<String> getVersion() async {
    packageInfop.PackageInfo packageInfo = await packageInfop.PackageInfo.fromPlatform();
    return _version = '${packageInfo.version}+${packageInfo.buildNumber}';

    // setState(() {});
  }

  static Future<int?> getAndroidApiLevel() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt; // Returns Android API level
    }
    return null; // Not Android
  }
}

class PackageInfo {}
