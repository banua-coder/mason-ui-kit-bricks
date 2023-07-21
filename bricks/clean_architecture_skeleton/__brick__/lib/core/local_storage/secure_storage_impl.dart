import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../constants/storage_constant.dart';
import '../di/service_locator.dart';
import '../log/log.dart';
import 'local_storage.dart';

@Named('secure')
@LazySingleton(as: LocalStorage)
class SecureStorageImpl implements LocalStorage {
  final FlutterSecureStorage storage;

  SecureStorageImpl(this.storage);

  @override
  Future<dynamic> get(String key) async => storage.read(key: key);

  @override
  Future<bool> remove(String key) async {
    try {
      await storage.delete(key: key);
      return true;
    } catch (e, trace) {
      getIt<Log>().console(
        e.toString(),
        type: LogType.error,
        stackTrace: trace,
      );

      return false;
    }
  }

  @override
  Future<bool> save(String key, dynamic value) async {
    try {
      await storage.write(key: key, value: value.toString());
      return true;
    } catch (e, trace) {
      getIt<Log>().console(
        e.toString(),
        type: LogType.error,
        stackTrace: trace,
      );

      return false;
    }
  }

  Future<Map<String, String>> getAuthorizationHeader() async {
    var token = await get(StorageConstant.bearerToken);

    if (token == null) {
      return {};
    }

    return {
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<bool> has(String key) async {
    return Future.value(storage.containsKey(key: key));
  }
}
