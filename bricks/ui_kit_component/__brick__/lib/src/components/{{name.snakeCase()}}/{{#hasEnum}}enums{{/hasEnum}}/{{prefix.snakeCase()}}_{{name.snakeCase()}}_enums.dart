{{#hasEnum}}
{{#enums}}
enum {{prefix.upperCase()}}{{name.pascalCase()}} {
  {{#values}}{{.}},{{/values}}
}

{{/enums}}
{{/hasEnum}}