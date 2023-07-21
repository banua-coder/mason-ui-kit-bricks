import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:{{name.snakeCase()}}_ui_kit/{{name.snakeCase()}}_ui_kit.dart';

import 'base/lifecycle_manager.dart';
import 'core/di/service_locator.dart';
import 'core/log/log.dart';
import 'router/observers/{{prefix.snakeCase()}}_route_observer.dart';
import 'router/{{prefix.snakeCase()}}_router.dart';

class {{name.pascalCase()}}App extends StatelessWidget {
  {{name.pascalCase()}}App({super.key});

  final router = getIt<{{prefix.upperCase()}}Router>();

  @override
  Widget build(BuildContext context) => {{prefix.upperCase()}}ComponentInit(
      builder: (context) => MaterialApp.router(
            title: 'Siap',
            theme: {{prefix.upperCase()}}Theme.main().copyWith(
              extensions: <ThemeExtension<dynamic>>[
                {{prefix.upperCase()}}ColorTheme.light,
              ],
            ),
            darkTheme: SHTheme.main().copyWith(
              extensions: <ThemeExtension<dynamic>>[
                {{prefix.upperCase()}}ColorTheme.dark,
              ],
            ),
            routerDelegate: AutoRouterDelegate(
              router,
              navigatorObservers: () => [
                {{prefix.upperCase()}}RouteObserver(),
              ],
            ),
            routeInformationParser: router.defaultRouteParser(),
            locale: const Locale('id', 'ID'),
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(
              builder: (context, child) => child == null
                  ? nil
                  : LifecycleManager(
                      child: child,
                      lifeCycle: (state) {
                        var logger = getIt<Log>();
                        switch (state) {
                          case AppLifecycleState.resumed:
                            logger.console('App is resumed.');
                            break;
                          case AppLifecycleState.inactive:
                            logger.console('App is inactive.');
                            break;
                          case AppLifecycleState.paused:
                            logger.console('App is paused.');
                            break;
                          case AppLifecycleState.detached:
                            logger.console('App is detached.');
                            break;
                        }
                      },
                    ),
            ),
          ));
}
