import 'dart:io';
import 'package:mason/mason.dart';
import 'package:yaml/yaml.dart';

void run(HookContext context) async {
  final logger = context.logger;

  // Check if properties key is present in the vars. If not, prompt the user for input.
  if (!context.vars.containsKey('properties')) {
    final numberOfProperties = int.parse(logger.prompt(
      'How many properties does your component have?: ',
      defaultValue: '0',
    ));

    List<Map<String, dynamic>> properties = [];

    for (var i = 0; i < numberOfProperties; i++) {
      var propertyName = logger.prompt(
        'Enter the name of property ${i + 1}: ',
      );
      var propertyType = logger.prompt(
        'Enter the type of property ${i + 1} (according to Flutter, e.g., String): ',
      );
      var isRequired = logger.confirm(
        'Is property ${i + 1} required? (yes/no): ',
        defaultValue: false,
      );
      var defaultValue = logger.prompt(
        'Enter the default value for property ${i + 1}: ',
        defaultValue: '',
      );

      properties.add({
        'name': propertyName,
        'type': propertyType,
        'isRequired': isRequired,
        'default': defaultValue,
      });
    }

    context.vars = {
      ...context.vars,
      'properties': properties,
    };
  }

  // Check if enums key is present in the vars. If not, prompt the user for input.
  if (!context.vars.containsKey('enums') && context.vars['hasEnum']) {
    final hasEnums = logger.confirm(
      'Does this component have any enum classes? (yes/no): ',
      defaultValue: false,
    );

    List<Map<String, dynamic>> enums = [];

    if (hasEnums) {
      final numberOfEnums = int.parse(logger.prompt(
        'How many enum classes does your component have?: ',
        defaultValue: '0',
      ));

      for (var i = 0; i < numberOfEnums; i++) {
        var enumName = logger.prompt(
          'Enter the name of enum class ${i + 1}: ',
        );

        List<String> enumValues = [];

        var numberOfEnumValues = int.parse(logger.prompt(
          'How many values does ${enumName} have?: ',
          defaultValue: '0',
        ));

        for (var j = 0; j < numberOfEnumValues; j++) {
          var enumValue = logger.prompt(
            'Enter the value for ${enumName} (Value ${j + 1}): ',
          );

          enumValues.add(enumValue);
        }

        enums.add({
          'name': enumName,
          'values': enumValues,
        });
      }
    }

    context.vars = {
      ...context.vars,
      'enums': enums,
    };
  }

  final directory = '${Directory.current.path}${Platform.pathSeparator}lib';
  List<String> folders;

  try {
    folders = directory.split(Platform.pathSeparator).toList();

    final libIndex = folders.indexWhere((folder) => folder == 'lib');

    final pubSpecFile =
        File('${folders.sublist(0, libIndex).join('/')}/pubspec.yaml');
    final content = await pubSpecFile.readAsString();
    final yamlMap = loadYaml(content);
    final packageName = yamlMap['name'];

    if (packageName == null) {
      throw PubspecException();
    }

    context.vars = {
      ...context.vars,
      'packageName': packageName,
      'componentPath':
          'src/components/${(context.vars['name'] as String).snakeCase}',
    };
  } on RangeError catch (_) {
    logger.alert(red.wrap('Could not find lib folder in $directory'));
    logger.alert(red.wrap('Re-run this brick inside your lib folder'));
    throw Exception();
  } on FileSystemException {
    logger.alert(
      red.wrap(
        'Could not find pubspec.yaml in ${directory.replaceAll('\\lib', '')}',
      ),
    );
  } on PubspecException {
    logger.alert(red.wrap('Could not read package name in pubspec.yaml'));
  } catch (e) {
    throw e;
  }
}

class PubspecException implements Exception {}
