import 'package:{{name.snakeCase()}}/core/log/log.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Analytics {
  String get _logPrefix => 'Analytics ';

  final FirebaseAnalytics _analytics;
  final Log _log;

  Analytics(this._analytics, this._log);

  Future<void> initialize() async {
    if (!kDebugMode) {
      await _analytics.setAnalyticsCollectionEnabled(false);
      _log.console('${_logPrefix}Disabled', type: LogType.info);
    } else {
      await _analytics.setAnalyticsCollectionEnabled(true);
      _log.console('${_logPrefix}Enabled', type: LogType.info);
    }
  }

  void log({required String name, Map<String, Object?>? params}) async {
    await FirebaseAnalytics.instance.logEvent(name: name, parameters: params);
  }

  Future<void> setUser(String identifier) async => _analytics.setUserId(
        id: identifier,
      );
}
