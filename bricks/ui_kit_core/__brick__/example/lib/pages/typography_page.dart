import 'package:flutter/material.dart';
import 'package:{{packageName}}/{{packageName}}.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Typography'),
      ),
      body: Column(
         mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.r),
            child: const Text(
            '{{fontFamily.upperCase()}}',
            ),
          ),
           Expanded(
            child: ListView.separated(
              itemCount: _textStyles.length,
              padding: EdgeInsets.all(20.r),
              itemBuilder: (context, index) => _textStyles[index],
              separatorBuilder: (context, index) => Container(
                height: 1,
                margin: EdgeInsets.symmetric(vertical: 16.h),
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static final _textStyles = [
    {{#typography}}SelectableText('{{name.titleCase()}}',
    style: {{prefix.upperCase()}}TextStyle.{{name.camelCase()}}(),),
    {{/typography}}
  ];
}
