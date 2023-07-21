// Package imports:
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@LazySingleton()
class PackageInfoUtil {
  final PackageInfo _packageInfo;

  PackageInfoUtil({
    required PackageInfo packageInfo,
  }) : _packageInfo = packageInfo;

  String version() => _packageInfo.version;

  String buildNumber() => _packageInfo.buildNumber;

  String appName() => _packageInfo.appName;

  String package() => _packageInfo.packageName;
}
