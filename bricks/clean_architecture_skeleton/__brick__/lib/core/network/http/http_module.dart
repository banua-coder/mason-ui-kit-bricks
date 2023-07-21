import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../../exception/exceptions.dart';
import '../../extension/num_x.dart';
import '../../extension/typedef.dart';
import '../../log/log.dart';
import '../api_exception.dart';
import 'http_client.dart';

abstract class HttpModule {
  HttpModule(HttpClient client) {
    _client = client;
  }

  @protected
  late HttpClient _client;

  @protected
  Log get log => getIt<Log>();

  Future<String> get authorizationToken => Future.value('');

  Future<JSON> get headerWithAuthorization async {
    var token = await authorizationToken;
    return {
      'Authorization': token,
      'Content-Type': 'application/vnd.api+json',
    };
  }

  JSON get headers => {
        'Content-Type': 'application/vnd.api+json',
      };

  JSON responseParser(Response response) {
    var data = <String, dynamic>{};

    try {
      data = jsonDecode(response.toString());
      log.console('Response: $data');
    } catch (e) {
      log.console('Parse Error', type: LogType.fatal);
      log.console(
        'Response format isn\'t as expected | ${response.realUri}',
        type: LogType.fatal,
      );
    }

    return data;
  }

  Future<JSON> _safeCallApi<T>(Future<Response<T>> call) async {
    try {
      var response = await call;
      return responseParser(response);
    } on DioException catch (error, stack) {
      var message = error.message;
      var code = error.response?.statusCode;
      log.console(
        'Dio Error: ${error.type}',
        type: LogType.fatal,
        stackTrace: stack,
      );
      log.console(error.message ?? '', type: LogType.fatal);

      List<DioExceptionType> dioTimeout = [
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.sendTimeout,
      ];

      if (dioTimeout.any((element) => error.type == element)) {
        throw ErrorRequestException(code ?? 0, message);
      }

      if (code == null) {
        throw ErrorRequestException(600, message);
      } else if (code >= 400 && code < 500) {
        throw ErrorRequestException(code, error.response?.data ?? message);
      } else if (code >= 500) {
        throw ServerException();
      } else {
        throw ErrorRequestException(600, message);
      }
    } catch (e, trace) {
      log.console('Exception: $e', type: LogType.fatal, stackTrace: trace);

      throw ErrorRequestException(600, e.toString());
    }
  }

  Future<JSON> get(
    String endpoint, {
    JSON? param,
    bool needAuthorization = true,
    bool cache = false,
    void Function(int, int)? onReceiveProgress,
  }) async {
    late Options options;

    options = cache
        ? CacheOptions(
            store: MemCacheStore(),
            maxStale: 1.days,
          ).toOptions()
        : Options();

    options = options.copyWith(
      headers: needAuthorization ? await headerWithAuthorization : headers,
    );

    var response = await _safeCallApi(
      _client.get(
        endpoint,
        queryParameters: param,
        options: options,
        onReceiveProgress: onReceiveProgress,
      ),
    );

    return response;
  }

  Future<JSON> post(
    String endpoint, {
    Object? body,
    JSON? param,
    bool needAuthorization = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    var options = Options();
    options = options.copyWith(
      headers: needAuthorization ? await headerWithAuthorization : headers,
    );

    var response = await _safeCallApi(
      _client.post(
        endpoint,
        queryParameters: param,
        data: body,
        onReceiveProgress: onReceiveProgress,
        options: options,
        onSendProgress: onSendProgress,
      ),
    );

    return response;
  }

  Future<JSON> put(
    String endpoint, {
    Object? body,
    JSON? param,
    bool needAuthorization = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    var options = Options();
    options = options.copyWith(
      headers: needAuthorization ? await headerWithAuthorization : headers,
    );

    var response = await _safeCallApi(
      _client.put(
        endpoint,
        queryParameters: param,
        data: body,
        onReceiveProgress: onReceiveProgress,
        options: options,
        onSendProgress: onSendProgress,
      ),
    );

    return response;
  }

  Future<JSON> patch(
    String endpoint, {
    Object? body,
    JSON? param,
    bool needAuthorization = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    var options = Options();
    options = options.copyWith(
      headers: needAuthorization ? await headerWithAuthorization : headers,
    );

    var response = await _safeCallApi(
      _client.patch(
        endpoint,
        queryParameters: param,
        data: body,
        onReceiveProgress: onReceiveProgress,
        options: options,
        onSendProgress: onSendProgress,
      ),
    );

    return response;
  }

  Future<JSON> delete(
    String endpoint, {
    Object? body,
    JSON? param,
    bool needAuthorization = true,
  }) async {
    var options = Options();
    options = options.copyWith(
      headers: needAuthorization ? await headerWithAuthorization : headers,
    );

    var response = await _safeCallApi(
      _client.delete(
        endpoint,
        queryParameters: param,
        data: body,
        options: options,
      ),
    );

    return response;
  }
}
