import 'package:flutter/material.dart';

class {{prefix.upperCase()}}Colors {
  const {{prefix.upperCase()}}Colors._();
  {{#colors}}{{#isMaterialColor}} 
  static const MaterialColor {{name.camelCase()}} = MaterialColor(
    0xFF{{defaultColor.upperCase()}},
    {
      {{#value}}{{level}}: Color(0xFF{{value.upperCase()}}),
      {{/value}}
    },
  );{{/isMaterialColor}}
  {{^isMaterialColor}}static const Color {{name.camelCase()}} = Color(0xFF{{value.upperCase()}});{{/isMaterialColor}}{{/colors}}
}
