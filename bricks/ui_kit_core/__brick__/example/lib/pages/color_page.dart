import 'package:flutter/material.dart';
import 'package:{{name.snakeCase()}}_ui_kit/{{name.snakeCase()}}_ui_kit.dart';

class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var {{prefix.camelCase()}}Colors = Theme.of(context).extension<{{prefix.upperCase()}}ColorTheme>()!;
    var names = {{prefix.camelCase()}}Colors
        .toString()
        .replaceAll('{{prefix.upperCase()}}ColorTheme(', '')
        .replaceAll(')', '')
        .split(', ');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colors'),
      ),
      body: ListView(
        children: List.generate(colorCollection({{prefix.camelCase()}}Colors).length, 
        (index) {
          var color = colorCollection({{prefix.camelCase()}}Colors)[index];
          var name = names[index].split(': ')[0];

          return ListTile(
            tileColor: color,
            title: SelectableText(
              '$color - $name',
            ),
          );
        },
        ),
      ),
    );
  }


  List<Color?> colorCollection({{prefix.upperCase()}}ColorTheme {{prefix.camelCase()}}Colors) => [
    {{#colors}}{{#isMaterialColor}}
    {{#value}}{{prefix.camelCase()}}Colors.{{name.camelCase()}}{{level}},
    {{/value}}{{/isMaterialColor}}
    {{^isMaterialColor}}{{prefix.camelCase()}}Colors.{{name.camelCase()}},{{/isMaterialColor}}{{/colors}}
  ];
}
