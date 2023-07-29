import 'package:flutter/material.dart';

import '../../../{{packageName}}.dart';

class {{prefix.upperCase()}}Theme {
  static ThemeData main() => ThemeData(
    primaryColor: {{prefix.upperCase()}}Colors.primary,
    textTheme: {{prefix.upperCase()}}TextStyle.mainTextTheme,
  );
}
