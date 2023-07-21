import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import '../../core/di/service_locator.dart';
import '../../core/use_case/use_case.dart';
import '../../shared/domain/use_case/get_profile.dart';
import '../../shared/domain/use_case/has_access_token.dart';

class {{prefix.upperCase()}}AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    var hasTokenResult = await getIt<HasAccessToken>().call(NoParams());

    await hasTokenResult.fold(
      (l) async {
        log('Denied', name: 'RouterGuard: Auth');
        // await router.replace(const LoginRoute());
      },
      (r) async {
        var result = await getIt<GetProfile>().call(NoParams());
        result.fold(
          (l) {
            log('Denied', name: 'RouterGuard: Auth');
            // router.replace(const LoginRoute());
          },
          (r) {
            log('Granted', name: 'RouterGuard: Auth');
            resolver.next();
          },
        );
        return;
      },
    );
  }
}
