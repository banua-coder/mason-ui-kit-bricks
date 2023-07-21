import 'package:injectable/injectable.dart';

import '../../../core/constants/storage_constant.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/exception/exceptions.dart';
import '../../../core/local_storage/local_storage.dart';

abstract class AccessTokenLocalDataSource {
  Future<String> getAccessToken();
  Future<bool> saveAccessToken(String token);
  Future<bool> hasAccessToken();
  Future<bool> deleteAccessToken();
}

@LazySingleton(as: AccessTokenLocalDataSource)
class AccessTokenLocalDataSourceImpl implements AccessTokenLocalDataSource {
  final _storage = getIt<LocalStorage>(instanceName: 'secure');

  AccessTokenLocalDataSourceImpl();

  @override
  Future<bool> deleteAccessToken() async {
    if (await hasAccessToken()) {
      return _storage.remove(StorageConstant.bearerToken);
    }

    return true;
  }

  @override
  Future<String> getAccessToken() async {
    var token = await _storage.get(StorageConstant.bearerToken);

    if (token == null) {
      throw NotFoundException();
    }

    return token;
  }

  @override
  Future<bool> hasAccessToken() async =>
      _storage.has(StorageConstant.bearerToken);

  @override
  Future<bool> saveAccessToken(String token) async => _storage.save(
        StorageConstant.bearerToken,
        token,
      );
}
