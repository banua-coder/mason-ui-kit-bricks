import 'package:flutter/material.dart';

import '../../../{{appName.snakeCase()}}_ui_kit.dart';

{{#isStateful}}  
class {{prefix.upperCase()}}{{name.pascalCase()}} extends StatefulWidget {
  const {{prefix.upperCase()}}{{name.pascalCase()}}({
    super.key,
    {{#properties}}{{#isRequired}}required{{/isRequired}} this.{{name.camelCase()}} {{#default}}= {{default}}{{/default}},
    {{/properties}}
  });
  
  {{#properties}}
  final {{type}} {{name.camelCase()}};
  {{/properties}}

  @override
  State<{{prefix.upperCase()}}{{name.pascalCase()}}> createState() => _{{prefix.upperCase()}}{{name.pascalCase()}}State();
}

class _{{prefix.upperCase()}}{{name.pascalCase()}}State extends State<{{prefix.upperCase()}}{{name.pascalCase()}}> {
  @override
  Widget build(BuildContext context) => Container();
}

{{/isStateful}}
{{^isStateful}}
class {{prefix.upperCase()}}{{name.pascalCase()}} extends StatelessWidget {
   const {{prefix.upperCase()}}{{name.pascalCase()}}({
    super.key,
    {{#properties}}{{#isRequired}}required {{/isRequired}}this.{{name.camelCase()}} {{#default}}= {{default}}{{/default}},
    {{/properties}}
  });
  
  {{#properties}}
  final {{type}} {{name.camelCase()}};
  {{/properties}}

  @override
  Widget build(BuildContext context) => Container();
}

{{/isStateful}}