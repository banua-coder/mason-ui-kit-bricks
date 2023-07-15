import 'package:flutter/material.dart';

import '../../../{{name.snakeCase()}}_ui_kit.dart';

class {{prefix.upperCase()}}Theme {
  static ThemeData main() => ThemeData(
    primaryColor: {{prefix.upperCase()}}Colors.primary,
    textTheme: {{prefix.upperCase()}}TextStyle.mainTextTheme,
  );
}
