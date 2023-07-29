import 'package:flutter/material.dart';
import 'package:{{packageName}}/{{packageName}}.dart';

import '/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => {{prefix.upperCase()}}ComponentInit(
        builder: (_) => MaterialApp(
          title: '{{name.titleCase()}} UI KIT',
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
          home: const HomePage(),
        ),
      );
}
