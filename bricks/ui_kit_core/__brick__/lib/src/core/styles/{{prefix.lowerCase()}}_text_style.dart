import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../{{name.snakeCase()}}_ui_kit.dart';

class {{prefix.upperCase()}}TextStyle {
  const {{prefix.upperCase()}}TextStyle._();

  static TextStyle _base({
    double fontSize = 14,
    FontWeight? fontWeight = FontWeight.w400,
    double letterSpacing = 0.0,
    TextDecoration? decoration,
    Color? color,
    double? height,
  }) => GoogleFonts.{{fontFamily.lowerCase()}}(
     fontSize: fontSize * 1.sp,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing * 1.sp,
        height: height,
        textBaseline: TextBaseline.alphabetic,
        decoration:decoration,
        locale: const Locale('en', 'US'),
        color: color,
  ); 

  //TODO: Define your text style variant and your main text theme

  static TextTheme mainTextTheme = TextTheme(
    {{#textTheme}}{{name.camelCase()}}: {{prefix.upperCase()}}TextStyle.{{style.camelCase()}}(),
    {{/textTheme}}
  );

  {{#typography}}
  static TextStyle {{name.camelCase()}}({
    {{#parameters}}{{#isRequired}}required {{/isRequired}}{{type.pascalCase()}} {{name.camelCase()}}{{#default}} = {{default}}{{/default}},
    {{/parameters}}
}) => _base(
    fontSize: {{fontSize}},
    {{#parameters}}{{name.camelCase()}}: {{name.camelCase()}},{{/parameters}}
  );
  {{/typography}}
}
