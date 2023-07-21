import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:uni_links/uni_links.dart';

import '../core/di/service_locator.dart';
import '../core/log/log.dart';

abstract class {{prefix.upperCase()}}DeepLink {
  Future<void> open();
  Future<void> routing(Uri? uri);
}

@LazySingleton(as: {{prefix.upperCase()}}DeepLink)
class {{prefix.upperCase()}}DeepLinkImpl implements {{prefix.upperCase()}}DeepLink {
  @override
  Future<void> open() async {
    var initialUri = await getInitialUri();
    await routing(initialUri);
  }

  @override
  Future<void> routing(Uri? uri) async {
    try {
      if (uri != null && uri.pathSegments.length > 1) {
        //
      } else {
        //
      }
    } catch (e) {
      getIt<Log>().console(e.toString(), type: LogType.error);
    }
  }
}
