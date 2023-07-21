import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/core/network/api_endpoint.dart';
import 'package:{{name.snakeCase()}}/core/network/http/modules/{{name.snakeCase()}}_http_module.dart';
import 'package:{{name.snakeCase()}}/shared/data/data_sources/profile_remote_data_source.dart';
import 'package:{{name.snakeCase()}}/shared/data/models/profile_model.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_injection.dart';

class Mock{{name.pascalCase()}}HttpModule extends Mock implements {{name.pascalCase()}}HttpModule {}

void main() {
  late {{name.pascalCase()}}HttpModule mockHttpModule;
  late ProfileRemoteDataSource remoteDataSource;

  setUp(
    () {
      mockHttpModule = Mock{{name.pascalCase()}}HttpModule();
      registerTestFactory<{{name.pascalCase()}}HttpModule>(mockHttpModule);
      remoteDataSource = ProfileRemoteDataSourceImpl();
    },
  );

  group(
    'ProfileRemoteDataSource',
    () {
      var profile =
          ProfileModel.fromJson(jsonFromFixture('profile_fixture.json'));
      group(
        'getProfile',
        () {
          test(
            'should return ProfileModel when request success',
            () async {
              // arrange
              when(
                () => mockHttpModule.get(ApiEndpoint.baseUrl),
              ).thenAnswer(
                  (_) async => jsonFromFixture('profile_fixture.json'));

              // act
              var result = await remoteDataSource.getProfile();

              // assert
              expect(result, profile);
              verify(
                () => mockHttpModule.get(ApiEndpoint.baseUrl),
              ).called(1);
            },
          );
        },
      );
    },
  );
}
