import 'package:injectable/injectable.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/network/api_endpoint.dart';
import '../../../core/network/http/modules/{{name.snakeCase()}}_http_module.dart';

import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final _httpClient = getIt<{{name.pascalCase()}}HttpModule>();

  @override
  Future<ProfileModel> getProfile() async {
    var response = await _httpClient.get(ApiEndpoint.baseUrl);

    return ProfileModel.fromJson(response);
  }
}
