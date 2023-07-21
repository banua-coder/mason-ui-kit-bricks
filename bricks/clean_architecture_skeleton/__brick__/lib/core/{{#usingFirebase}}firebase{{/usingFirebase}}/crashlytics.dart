import 'package:{{name.snakeCase()}}/core/log/log.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Crashlytics {
  String get _logPrefix => 'Crashlytics: ';

  final FirebaseCrashlytics _crashlytics;
  final Log _log;

  Crashlytics(this._crashlytics, this._log);

  Future<void> initialize() async {
    if (kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(false);
      _log.console('${_logPrefix}Disabled', type: LogType.info);
    } else {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
      _log.console('${_logPrefix}Enabled', type: LogType.info);
    }

    if (_crashlytics.isCrashlyticsCollectionEnabled) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      PlatformDispatcher.instance.onError = (error, stack) {
        report(error, stack, fatal: true);
        return true;
      };
    }
  }

  Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
    _log.console(
      '${_logPrefix}User identifier set to $identifier',
      type: LogType.info,
    );
  }

  Future<void> report(
    dynamic error,
    StackTrace? trace, {
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(error, trace, fatal: fatal);
  }
}
