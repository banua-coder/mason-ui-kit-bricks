import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import '../../../config/env.dart';
import '../../extension/num_x.dart';
import 'http_setting.dart';
import 'interceptors/logging_interceptor.dart';

class HttpClient extends DioMixin {
  HttpClient._(HttpSetting setting) {
    options = BaseOptions(
      baseUrl: setting.baseUrl,
      contentType: setting.contentType,
      connectTimeout: setting.timeout.connectTimeout.milliseconds,
      sendTimeout: setting.timeout.sendTimeout.milliseconds,
      receiveTimeout: setting.timeout.receiveTimeout.milliseconds,
    );

    httpClientAdapter = IOHttpClientAdapter();
    RetryInterceptor retryInterceptor = RetryInterceptor(
      dio: this,
      logPrint: dev.log,
      retries: 7,
      retryDelays: List.generate(
        7,
        (index) => math
            .min(
              (3 ^ (index + 1)) + (index * 1000 + math.Random().nextInt(1000)),
              5000,
            )
            .milliseconds,
      ),
    );

    interceptors.add(retryInterceptor);

    interceptors.addAll(
      setting.interceptors ?? defaultInterceptors,
    );
  }

  static HttpClient init([HttpSetting? setting]) {
    return HttpClient._(setting ?? HttpSetting(baseUrl: Env.apiBaseUrl));
  }

  static List<Interceptor> defaultInterceptors = [
    LoggingInterceptor(),
  ];
}
