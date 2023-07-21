import 'dart:async';

{{#usingFirebase}}
import 'core/firebase/analytics.dart';
import 'core/firebase/crashlytics.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
{{/usingFirebase}}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'injection.dart';
import 'core/di/service_locator.dart';
import 'core/i18n/translations.g.dart';
import 'core/log/log.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        LocaleSettings.useDeviceLocale();
  {{#usingFirebase}}
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
   {{/usingFirebase}}
        await configureDependencies();
        await Future.wait(
          [
            getIt.allReady(),
              {{#usingFirebase}}
            getIt<Analytics>().initialize(),
            getIt<Crashlytics>().initialize(),
            {{/usingFirebase}}
            initializeDateFormatting('id'),
            initializeDateFormatting('en'),
            SystemChrome.setPreferredOrientations(
              [
                DeviceOrientation.portraitUp,
              ],
            ),
          ],
        );
        EasyLoading.instance
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.light
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..maskType = EasyLoadingMaskType.black
          ..userInteractions = true
          ..dismissOnTap = false;

        Intl.systemLocale = 'en';

        runApp(
          MultiBlocProvider(
            providers: Injection.instance.initBloc(),
            child: {{name.pascalCase()}}App(
              key: const Key('{{name.paramCase()}}-App'),
            ),
          ),
        );
      },
      (error, stack) {
         {{#usingFirebase}}
        getIt<Crashlytics>().report(error, stack)  
        {{/usingFirebase}}
        {{^usingFirebase}}
        getIt<Log>().console(error.toString(), type: LogType.fatal);
        {{/usingFirebase}}
      },
    );
