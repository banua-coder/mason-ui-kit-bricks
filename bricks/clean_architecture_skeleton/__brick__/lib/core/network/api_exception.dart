import 'package:equatable/equatable.dart';

import '../constants/json_constant.dart';
import '../extension/typedef.dart';
import 'api_error_type.dart';

abstract class ApiException implements Exception {
  final String? _prefix;
  final String? _message;

  ApiException(this._prefix, this._message);

  @override
  String toString() => '$_prefix: $_message';
}

class ErrorRequestException extends ApiException {
  final List<ApiError>? errors;
  final int code;
  final dynamic body;

  ErrorRequestException(this.code, this.body, {this.errors})
      : super('Error $code', '$body');

  String get errorMessage {
    if (body is String) return body;
    if (body is JSON) {
      var errorMap = body as JSON;
      if (errorMap.containsKey(JsonConstant.message)) {
        return errorMap[JsonConstant.message];
      } else if (errorMap.containsKey(JsonConstant.data)) {
        return errorMap['errors'][0]['message'];
      }
    }

    throw UnimplementedError('Unhandled Error: $body');
  }

  String get errorType {
    if (body is JSON) {
      var errorMap = body as JSON;
      if (errorMap.containsKey('error_type')) {
        return body['error_type'];
      } else if (errorMap.containsKey('errCode')) {
        return body['errCode'];
      }
    }
    return ApiErrorType.unknown;
  }
}

class ApiError extends Equatable {
  final String? id;
  final String status;
  final String title;
  final String? code;
  final String? detail;
  final ErrorLinks? links;
  final ErrorSource? source;

  const ApiError({
    this.id,
    required this.status,
    required this.title,
    this.code,
    this.detail,
    this.links,
    this.source,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        status: json[JsonConstant.status],
        title: json[JsonConstant.title],
        links: ErrorLinks.fromJson(
          json[JsonConstant.links],
        ),
        code: json[JsonConstant.code],
        detail: json[JsonConstant.detail],
        id: json[JsonConstant.id],
        source: json[JsonConstant.source],
      );

  @override
  List<Object?> get props => [
        id,
        status,
        title,
        code,
        detail,
        links,
        source,
      ];
}

class ErrorSource extends Equatable {
  final String pointer;
  final String? parameter;
  final String? header;

  const ErrorSource({required this.pointer, this.parameter, this.header});

  factory ErrorSource.fromJson(Map<String, dynamic> json) => ErrorSource(
        pointer: json[JsonConstant.pointer],
        parameter: json[JsonConstant.parameter],
        header: json[JsonConstant.header],
      );

  @override
  List<Object?> get props => [pointer, parameter, header];
}

class ErrorLinks extends Equatable {
  final String about;
  final String type;

  const ErrorLinks({
    required this.about,
    required this.type,
  });

  factory ErrorLinks.fromJson(Map<String, dynamic> json) => ErrorLinks(
        about: json[JsonConstant.about],
        type: json[JsonConstant.type],
      );

  @override
  List<Object?> get props => [about, type];
}
