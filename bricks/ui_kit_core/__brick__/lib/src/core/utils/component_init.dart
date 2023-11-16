import 'package:flutter/material.dart';

import 'package:{{packageName}}/{{packageName}}.dart';


class {{prefix.upperCase()}}ComponentInit extends StatelessWidget {
  const {{prefix.upperCase()}}ComponentInit({super.key, required this.builder,  this.designSize,});

  final Widget Function(BuildContext context) builder;
  final Size? designSize;

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQueryData.fromView(View.of(context)),
    child: LayoutBuilder(
      builder: (_, constraints) {
        if(constraints.maxWidth != 0) {
          ScreenUtil.init(
            _, 
            designSize: Size(
             designSize?.width ?? constraints.maxWidth,
             designSize?.height ?? constraints.maxHeight,
            ),
          );

          return builder(context);
        }

        return nil;
      },
    ),
  );
}
