import 'package:equatable/equatable.dart';

import '../i18n/translations.g.dart';
import '../network/api_error_type.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {
  final String message;

  NetworkFailure({this.message = 'Seems like you have a connection issues!'});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

class ClientFailure extends Failure {
  final String message;

  ClientFailure({
    String? errorMessage,
  }) : message = errorMessage ?? translate.failures.client;

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  final String message;
  final String errorType;
  final int? statusCode;

  ServerFailure({
    String? errorMessage,
    this.errorType = ApiErrorType.unknown,
    this.statusCode = 500,
  }) : message = errorMessage ?? translate.failures.server;

  @override
  List<Object?> get props => [
        message,
        errorType,
        statusCode,
      ];

  @override
  String toString() => '[$statusCode] - $message';
}

class NotFoundFailure extends Failure {
  final String message;
  final String errorType;
  final int? statusCode;

  NotFoundFailure({
    String? errorMessage,
    this.errorType = ApiErrorType.notFound,
    this.statusCode = 404,
  }) : message = errorMessage ?? translate.failures.not_found;

  @override
  List<Object?> get props => [
        message,
        errorType,
        statusCode,
      ];

  @override
  String toString() => '[$statusCode] - $message';
}

class UnauthorizedFailure extends Failure {
  final String message;
  final String errorType;
  final int? statusCode;

  UnauthorizedFailure({
    String? errorMessage,
    this.errorType = ApiErrorType.unauthorized,
    this.statusCode = 401,
  }) : message = errorMessage ?? translate.failures.unauthorized;

  @override
  List<Object?> get props => [
        message,
        errorType,
        statusCode,
      ];

  @override
  String toString() => '[$statusCode] - $message';
}

class TimeoutFailure extends Failure {}

class PermissionFailure extends Failure {
  final String message;
  final String permissionStatus;

  PermissionFailure({
    this.message = 'Permission not granted!',
    this.permissionStatus = 'denied',
  });

  @override
  List<Object?> get props => [
        message,
        permissionStatus,
      ];
}

class FormValidationFailure extends Failure {
  final String message;
  final int code;
  final Map<String, dynamic>? errorBody;

  FormValidationFailure({
    required this.code,
    required this.message,
    this.errorBody,
  });

  @override
  List<Object?> get props => [code, message, errorBody];

  @override
  String toString() => '$code - $message';

  String getValidationMessage(String key) {
    if (errorBody == null) return 'Invalid input';
    var value = errorBody![key];

    if (value is List) {
      return value.join(' ');
    }

    return value.toString();
  }
}
