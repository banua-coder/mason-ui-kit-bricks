import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import '../../core/di/service_locator.dart';
import '../../core/use_case/use_case.dart';
import '../../shared/domain/use_case/get_profile.dart';
import '../../shared/domain/use_case/has_access_token.dart';

class {{prefix.upperCase()}}GuestGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    var hasTokenResult = await getIt<HasAccessToken>().call(NoParams());

    await hasTokenResult.fold(
      (l) async {
        log('Granted', name: 'RouterGuard: Guest');
        resolver.next();
      },
      (r) async {
        var result = await getIt<GetProfile>().call(NoParams());
        result.fold(
          (l) {
            log('Granted', name: 'RouterGuard: Guest');
            resolver.next();
          },
          (r) {
            log('Denied', name: 'RouterGuard: Guest');
            // router.replace(
            //   MainRoute(profile: r),
            // );
          },
        );
      },
    );
  }
}
