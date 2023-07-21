import 'package:injectable/injectable.dart';

import '../../../../shared/domain/use_case/get_access_token.dart';
import '../../../di/service_locator.dart';
import '../../../use_case/use_case.dart';
import '../http_client.dart';
import '../http_module.dart';

@LazySingleton()
class {{name.pascalCase()}}HttpModule extends HttpModule {
  String _token = '';

  {{name.pascalCase()}}HttpModule() : super(getIt<HttpClient>(instanceName: 'mainHttpClient'));

  void setToken(String token) {
    _token = 'Bearer $token';
  }

  @override
  Future<String> get authorizationToken async {
    var result = await getIt<GetAccessToken>().call(NoParams());

    result.fold((l) => null, (r) => setToken(r));

    return _token;
  }
}
