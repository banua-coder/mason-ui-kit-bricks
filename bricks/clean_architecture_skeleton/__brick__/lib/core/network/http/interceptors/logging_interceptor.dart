import 'package:dio/dio.dart';

import '../../../di/service_locator.dart';

import '../../../log/log.dart';

class LoggingInterceptor extends Interceptor {
  Log get log => getIt<Log>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.console('HTTP REQUEST');
    log.console('==============================');

    log.console(
      '${options.method.toUpperCase()} ${(options.baseUrl) + options.path}',
    );

    log.console('Headers:');
    options.headers.forEach(
      (k, v) => log.console('$k: $v'),
    );

    log.console('Query Parameters:');
    options.queryParameters.forEach(
      (k, v) => log.console('$k: $v'),
    );

    if (options.data != null) {
      log.console('Body: ${options.data}');
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    log.console('HTTP RESPONSE');
    log.console('==============================');

    log.console(
      '${response.statusCode} (${response.statusMessage})'
      '${response.requestOptions.baseUrl + response.requestOptions.path}',
    );

    log.console('Headers:');
    response.headers.forEach(
      (k, v) => log.console('$k: $v'),
    );

    log.console('Body: ${response.data}');

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    log.console(
      'HTTP ERROR',
      type: LogType.error,
    );
    log.console('==============================', type: LogType.error);

    var request = err.requestOptions;

    if (err.response != null) {
      var response = err.response!;
      log.console(
        '${err.response!.statusCode} (${err.response!.statusMessage})'
        '${request.baseUrl}${request.path}',
        type: LogType.error,
      );

      log.console('Body: ${response.data}', type: LogType.error);
    } else {
      log.console(
        '${err.error} (${err.type})'
        '${request.baseUrl}${request.path}',
        type: LogType.error,
      );
    }

    return super.onError(err, handler);
  }
}
