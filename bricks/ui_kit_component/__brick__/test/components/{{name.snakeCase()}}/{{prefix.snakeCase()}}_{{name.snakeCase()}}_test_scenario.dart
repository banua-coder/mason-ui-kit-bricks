import 'package:flutter/material.dart';
import 'package:{{packageName}}/{{packageName}}.dart';

import '../../util/{{prefix.snakeCase()}}_component_init_test.dart';
import '../../util/widget_test_scenario_model.dart';

List<WidgetTestScenarioModel> {{name.camelCase()}}TestScenario = [
  WidgetTestScenarioModel(
    title: '{{name.titleCase()}} Test',
    widget: {{prefix.upperCase()}}ComponentInitTest(
      child:  Container(), //TODO: add your first test case for this widget,
    ),
  ),
];