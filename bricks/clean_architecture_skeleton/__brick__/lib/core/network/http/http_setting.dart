// Package imports:
import 'package:dio/dio.dart';

class HttpSetting {
  final bool useHttp2;
  final String baseUrl;
  final String contentType;
  final HttpTimeout timeout;
  final List<Interceptor>? interceptors;

  const HttpSetting({
    required this.baseUrl,
    this.interceptors,
    this.useHttp2 = false,
    this.contentType = 'application/vnd.api+json',
    this.timeout = const HttpTimeout(),
  });
}

class HttpTimeout {
  final int connectTimeout;
  final int sendTimeout;
  final int receiveTimeout;

  const HttpTimeout({
    this.connectTimeout = 30000,
    this.sendTimeout = 20000,
    this.receiveTimeout = 20000,
  });
}
