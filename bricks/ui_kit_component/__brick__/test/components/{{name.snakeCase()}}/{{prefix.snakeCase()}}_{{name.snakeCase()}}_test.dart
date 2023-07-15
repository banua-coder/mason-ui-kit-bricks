import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '{{prefix.snakeCase()}}_{{name.snakeCase()}}_test_scenario.dart';

void main() {
  group(
    '{{name.titleCase()}} Test',
    () {
       testWidgets(
         {{name.camelCase()}}TestScenario[0].title,
        (WidgetTester tester) async {
          debugDefaultTargetPlatformOverride = TargetPlatform.android;

          await tester.pumpWidget({{name.camelCase()}}TestScenario[0].widget);

          // expect(find.text('Title'), findsOneWidget);
          debugDefaultTargetPlatformOverride = null;
        },
      );
    },
  );
}
