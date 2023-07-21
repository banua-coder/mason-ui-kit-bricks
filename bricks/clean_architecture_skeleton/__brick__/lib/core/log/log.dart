import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

enum LogType {
  verbose,
  debug,
  info,
  warning,
  error,
  fatal,
}

@LazySingleton()
class Log {
  final Logger _logger;

  const Log(this._logger);

  void console(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    LogType type = LogType.debug,
  }) async {
    switch (type) {
      case LogType.verbose:
        _logger.v(message, error, stackTrace);
        break;
      case LogType.debug:
        _logger.d(message, error, stackTrace);
        break;
      case LogType.info:
        _logger.d(message, error, stackTrace);
        break;
      case LogType.warning:
        _logger.w(message, error, stackTrace);
        break;
      case LogType.error:
        _logger.e(message, error, stackTrace);
        break;
      case LogType.fatal:
        _logger.wtf(message, error, stackTrace);
        break;
    }
  }
}
