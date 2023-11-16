import 'package:flutter/material.dart';

import 'package:{{packageName}}/{{packageName}}.dart';

class {{prefix.upperCase()}}ColorTheme extends ThemeExtension<{{prefix.upperCase()}}ColorTheme> {

  const {{prefix.upperCase()}}ColorTheme({
    {{#colors}}{{#isMaterialColor}}
    {{#value}}this.{{name.camelCase()}}{{level}},
    {{/value}}{{/isMaterialColor}}
    {{^isMaterialColor}}this.{{name.camelCase()}},{{/isMaterialColor}}{{/colors}}
  });

  {{#colors}}{{#isMaterialColor}}
  {{#value}}final Color? {{name.camelCase()}}{{level}};
  {{/value}}{{/isMaterialColor}}
  {{^isMaterialColor}}final Color? {{name.camelCase()}};{{/isMaterialColor}}{{/colors}}
  @override
  ThemeExtension<{{prefix.upperCase()}}ColorTheme> copyWith({
    {{#colors}}{{#isMaterialColor}}
    {{#value}}Color? {{name.camelCase()}}{{level}},
    {{/value}}{{/isMaterialColor}}
    {{^isMaterialColor}}Color? {{name.camelCase()}},{{/isMaterialColor}}{{/colors}}
  }) => {{prefix.upperCase()}}ColorTheme(
    {{#colors}}{{#isMaterialColor}}
    {{#value}}{{name.camelCase()}}{{level}}: {{name.camelCase()}}{{level}} ?? this.{{name.camelCase()}}{{level}},
    {{/value}}{{/isMaterialColor}}
    {{^isMaterialColor}}{{name.camelCase()}}: {{name.camelCase()}} ?? this.{{name.camelCase()}},{{/isMaterialColor}}{{/colors}}
  );

  @override
  ThemeExtension<{{prefix.upperCase()}}ColorTheme> lerp(
     covariant ThemeExtension<{{prefix.upperCase()}}ColorTheme>? other,
    double t,
  ) {
    if(other is! {{prefix.upperCase()}}ColorTheme){
      return this;
    }

    return {{prefix.upperCase()}}ColorTheme(
       {{#colors}}{{#isMaterialColor}}
       {{#value}}{{name.camelCase()}}{{level}}: Color.lerp({{name.camelCase()}}{{level}}, other.{{name.camelCase()}}{{level}}, t),
       {{/value}}{{/isMaterialColor}}
       {{^isMaterialColor}}{{name.camelCase()}}: Color.lerp({{name.camelCase()}}, other.{{name.camelCase()}}, t),{{/isMaterialColor}}{{/colors}}
    );
  }

  /// Light color scheme
  static final {{prefix.upperCase()}}ColorTheme light =  {{prefix.upperCase()}}ColorTheme(
      {{#colors}}{{#isMaterialColor}}
      {{#value}}{{name.camelCase()}}{{level}}: {{prefix.upperCase()}}Colors.{{name.camelCase()}}[{{level}}],
      {{/value}}{{/isMaterialColor}}
      {{^isMaterialColor}}{{name.camelCase()}}: {{prefix.upperCase()}}Colors.{{name.camelCase()}},{{/isMaterialColor}}{{/colors}}
  );
  
  /// Dark color scheme
  static final {{prefix.upperCase()}}ColorTheme dark =  {{prefix.upperCase()}}ColorTheme(
      {{#colors}}{{#isMaterialColor}}
      {{#value}}{{name.camelCase()}}{{level}}: {{prefix.upperCase()}}Colors.{{name.camelCase()}}[{{level}}],
      {{/value}}{{/isMaterialColor}}
      {{^isMaterialColor}}{{name.camelCase()}}: {{prefix.upperCase()}}Colors.{{name.camelCase()}},{{/isMaterialColor}}{{/colors}}
  );

  @override
  String toString() {
    return '{{prefix.upperCase()}}ColorTheme('
      {{#colors}}{{#isMaterialColor}}
      {{#value}}'{{name.camelCase()}}{{level}}: ${{name.camelCase()}}{{level}}, '
      {{/value}}{{/isMaterialColor}}
      {{^isMaterialColor}}'{{name.camelCase()}}: ${{name.camelCase()}}, '{{/isMaterialColor}}{{/colors}}
    ')';
  }
}
