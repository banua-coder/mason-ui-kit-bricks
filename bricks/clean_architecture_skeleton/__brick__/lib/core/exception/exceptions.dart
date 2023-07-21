import '../i18n/translations.g.dart';

abstract class AppException implements Exception {
  final String message;

  const AppException({required this.message});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException({
    String? message,
  }) : super(
          message: message ?? translate.failures.server,
        );
}

class CacheException extends AppException {
  CacheException({
    String? message,
  }) : super(message: message ?? translate.failures.cache);
}

class PermissionException extends AppException {
  PermissionException({
    String? message,
  }) : super(message: message ?? translate.failures.permission);
}

class UploadException extends AppException {
  UploadException({String? message})
      : super(message: message ?? translate.failures.upload);
}

class NotFoundException extends AppException {
  NotFoundException({String? message})
      : super(message: message ?? translate.failures.not_found);
}
