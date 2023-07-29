import 'package:flutter/material.dart';
import 'package:{{packageName}}/{{packageName}}.dart';

class {{prefix.upperCase()}}ComponentInitTest extends StatelessWidget {
  const {{prefix.upperCase()}}ComponentInitTest({
    super.key, 
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => {{prefix.upperCase()}}ComponentInit(
    builder: (_) => MaterialApp(
      title: '{{name.titleCase()}} UI Kit',
      theme: {{prefix.upperCase()}}Theme.main().copyWith(
        extensions: <ThemeExtension<dynamic>>[
          {{prefix.upperCase()}}ColorTheme.light,
        ],
      ),
      darkTheme: {{prefix.upperCase()}}Theme.main().copyWith(
        extensions: <ThemeExtension<dynamic>>[
          {{prefix.upperCase()}}ColorTheme.dark,
        ],
      ),
      home: child,
    ),
  );
}
