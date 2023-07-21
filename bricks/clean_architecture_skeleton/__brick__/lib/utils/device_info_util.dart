import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DeviceInfoUtil {
  final DeviceInfoPlugin _deviceInfoPlugin;

  DeviceInfoUtil({
    required DeviceInfoPlugin deviceInfoPlugin,
  }) : _deviceInfoPlugin = deviceInfoPlugin;

  Future<String> name() async {
    var deviceInfo = StringBuffer();
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfoPlugin.androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      deviceInfo.writeAll([
        'Android ',
        release,
        ' (SDK ',
        sdkInt.toString(),
        '), ',
        manufacturer,
        ' ',
        model,
      ]);
    } else if (Platform.isIOS) {
      var iosInfo = await _deviceInfoPlugin.iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      deviceInfo.writeAll([
        systemName,
        ' ',
        version,
        ', ',
        name,
        ' ',
        model,
      ]);
    }

    return deviceInfo.toString();
  }

  Future<bool> isPhysicalDevice() async {
    var isPhysicalDevice = false;
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfoPlugin.androidInfo;
      isPhysicalDevice = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      var iosInfo = await _deviceInfoPlugin.iosInfo;
      isPhysicalDevice = iosInfo.isPhysicalDevice;
    }

    return isPhysicalDevice;
  }

  Future<int> getSdkInt() async {
    var androidInfo = await _deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt;
  }
}
