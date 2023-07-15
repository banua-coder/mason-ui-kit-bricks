import 'package:flutter/material.dart';


import '../../../{{name.snakeCase()}}_ui_kit.dart';

class {{prefix.upperCase()}}ComponentInit extends StatelessWidget {
  const {{prefix.upperCase()}}ComponentInit({super.key, required this.builder});

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQueryData.fromView(View.of(context)),
    child: LayoutBuilder(
      builder: (_, constraints) {
        if(constraints.maxWidth != 0) {
          ScreenUtil.init(
            _, 
            designSize: Size(
              constraints.maxWidth,
              constraints.maxHeight,
            ),
          );

          return builder(context);
        }

        return nil;
      },
    ),
  );
}
