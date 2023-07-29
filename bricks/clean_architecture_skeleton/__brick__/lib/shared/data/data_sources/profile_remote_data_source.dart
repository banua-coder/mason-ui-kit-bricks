import 'package:injectable/injectable.dart';

import '../../../core/constants/json_constant.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/network/api_endpoint.dart';
import '../../../core/network/http/modules/{{name.snakeCase()}}_http_module.dart';

import '../dtos/profile_dto.dart';
import '../mapper/profile_mapper.dart';
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

    if(response.containsKey(JsonConstant.attributes)) {
      var profileDto = ProfileDto.fromJson(response); 
      return ProfileMapper.fromDto(profileDto);
    }

    return ProfileModel.fromJson(response);
  }
}
