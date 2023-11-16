import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:{{packageName}}/{{packageName}}.dart';

class {{prefix.upperCase()}}Theme {
  static ThemeData main({bool isDarkMode = false}) => isDarkMode ? 
   ThemeData(
    primaryColor: {{prefix.upperCase()}}Colors.primary,
    fontFamily: GoogleFonts.{{fontFamily.camelCase()}}().fontFamily,
    textTheme: {{prefix.upperCase()}}TextStyle.darkTextTheme,
   )  :
   ThemeData(
    primaryColor: {{prefix.upperCase()}}Colors.primary,
    fontFamily: GoogleFonts.{{fontFamily.camelCase()}}().fontFamily,
    textTheme: {{prefix.upperCase()}}TextStyle.mainTextTheme,
  );
}
