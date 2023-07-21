import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../core/constants/json_constant.dart';
import '../../../core/constants/storage_constant.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../domain/entities/profile.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getProfile();
  Future<DateTime> getExpiredAt();
  Future<bool> saveProfile(Profile profile);
  Future<bool> updateExpiredAt();
  Future<bool> deleteProfile();
  Future<bool> deleteExpiredAt();
}

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final _storage = getIt<LocalStorage>(instanceName: 'secure');

  @override
  Future<bool> deleteExpiredAt() async =>
      _storage.remove(StorageConstant.userExpiredAt);

  @override
  Future<bool> deleteProfile() => _storage.remove(StorageConstant.user);

  @override
  Future<DateTime> getExpiredAt() async {
    var dateString = await _storage.get(StorageConstant.userExpiredAt);

    if (dateString == null) {
      return DateTime.now();
    }

    var date = DateTime.parse(dateString);

    return date;
  }

  @override
  Future<ProfileModel?> getProfile() async {
    var dataString = await _storage.get(StorageConstant.user);

    if (dataString == null) {
      return null;
    }

    var data = jsonDecode(dataString)[JsonConstant.data];
    var json = <String, dynamic>{
      JsonConstant.id: data[JsonConstant.id],
      ...data[JsonConstant.attributes],
    };

    return ProfileModel.fromJson(json);
  }

  @override
  Future<bool> saveProfile(Profile profile) async {
    var json = ProfileModel.fromEntity(profile).toJson();
    return _storage.save(StorageConstant.user, jsonEncode(json));
  }

  @override
  Future<bool> updateExpiredAt() async {
    var data = DateTime.now().toString();
    return _storage.save(StorageConstant.userExpiredAt, data);
  }
}
