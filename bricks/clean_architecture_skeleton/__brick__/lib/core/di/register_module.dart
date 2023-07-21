import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
{{#usingFirebase}}
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
  {{/usingFirebase}}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../log/filter/release_log_filter.dart';
import '../log/printer/simple_log_printer.dart';
import '../network/api_endpoint.dart';
import '../network/http/http_client.dart';
import '../network/http/http_setting.dart';


@module
abstract class RegisterModule {
  Logger get logger => Logger(
        filter: ReleaseLogFilter(),
        printer: SimpleLogPrinter(),
      );

  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();
  {{#usingFirebase}}
  FirebaseAnalytics get analytics => FirebaseAnalytics.instance;
  FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;
  {{/usingFirebase}}
   FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
          keyCipherAlgorithm:
              KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
          storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
        ),
      );

@preResolve
  Future<PackageInfo> get packageInfo async {
    var instance = await PackageInfo.fromPlatform();
    return instance;
  }
  
  @Named('mainHttpClient')
  HttpClient get ctHttpClient => HttpClient.init(
        HttpSetting(baseUrl: ApiEndpoint.baseUrl),
      );
}
