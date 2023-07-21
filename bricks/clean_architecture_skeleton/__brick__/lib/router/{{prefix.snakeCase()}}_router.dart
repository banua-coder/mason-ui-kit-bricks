import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
part '{{prefix.snakeCase()}}_router.gr.dart';


@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
@LazySingleton()
class {{prefix.upperCase()}}Router extends _${{prefix.upperCase()}}Router {
 @override
  List<AutoRoute> get routes => [];
}