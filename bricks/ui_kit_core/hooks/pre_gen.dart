import 'dart:io';

import 'package:mason/mason.dart';
import 'package:yaml/yaml.dart';

void run(HookContext context) async {
  final logger = context.logger;

  if (!context.vars.containsKey('colors')) {
    var numberOfColors = int.parse(
      logger.prompt(
        'How many colors does your design have?: ',
        defaultValue: '0',
      ),
    );

    if (numberOfColors <= 0) {
      logger.err(
        red.wrap(
          'The number of colors is required and must be more than 0!',
        ),
      );
      exit(1);
    }

    List<Map<String, dynamic>> colors = [];

    for (var i = 0; i < numberOfColors; i++) {
      var colorName = logger.prompt(
        '${i + 1}. What is the name of the color?: ',
        defaultValue: 'primary',
      );
      var isMaterialColor = logger.confirm(
        '${i + 1}. Is this color a material color?: ',
        defaultValue: false,
      );
      var colorHex = isMaterialColor
          ? logger.prompt(
              '${i + 1}. What is the default color for this Material Color?: ',
            )
          : logger.prompt(
              '${i + 1}. What is the hex code for this color?: ',
            );
      if (isMaterialColor) {
        var numberOfRange = int.parse(
          logger.prompt(
            '${i + 1}. How many levels of this material color?: ',
            defaultValue: '0',
          ),
        );

        if (numberOfRange <= 0) {
          logger.err(
            red.wrap(
              'Material colors must have at least 1 level!',
            ),
          );
          exit(1);
        }

        List<Map<String, dynamic>> materialColors = [];

        for (var j = 0; j < numberOfRange; j++) {
          var level = int.parse(
            logger.prompt(
              '${i + 1}.${j + 1}. What is the level of this color?: ',
              defaultValue: '50',
            ),
          );

          var value = logger.prompt(
            '${i + 1}.${j + 1}. What is the hex of this color?: ',
          );
          materialColors.add(
            {
              'level': level,
              'value': value,
            },
          );
        }

        colors.add(
          {
            'name': colorName,
            'isMaterialColor': isMaterialColor,
            'defaultColor': colorHex,
            'value': materialColors,
          },
        );
      } else {
        colors.add(
          {
            'name': colorName,
            'isMaterialColor': isMaterialColor,
            'value': colorHex,
          },
        );
      }
    }

    context.vars = {
      ...context.vars,
      'colors': colors,
    };
    logger.info(
      green.wrap('Colors generated successfully!'),
    );
  }

  if (!context.vars.containsKey('typography')) {
    var numberOfTextStyles = int.parse(
      logger.prompt(
        'How many text styles does your design have?: ',
        defaultValue: '0',
      ),
    );

    if (numberOfTextStyles <= 0) {
      logger.warn(
        yellow.wrap(
          'The number of text styles is 0, so it will be skipped.',
        ),
      );
    } else {
      List<Map<String, dynamic>> textStyles = [];
      List<Map<String, String>> availableParams = [
        {
          'type': 'FontWeight?',
          'name': 'fontWeight',
        },
        {
          'type': 'TextDecoration?',
          'name': 'decoration',
        },
        {
          'type': 'Color?',
          'name': 'color',
        }
      ];

      for (var i = 0; i < numberOfTextStyles; i++) {
        var textStyleName = logger.prompt(
          '${i + 1}. What is the name of your text style?: ',
          defaultValue: 'title',
        );
        var fontSize = int.parse(
          logger.prompt(
            '${i + 1}. What is the fontSize of this text style?: ',
            defaultValue: '42',
          ),
        );

        List<Map<String, String>> selectedParams = [];

        for (var param in availableParams) {
          var isCustomizable = logger.confirm(
            '${i + 1}. Do you want to include ${param['type']} as a customizable param?: ',
            defaultValue: true,
          );

          if (!isCustomizable) {
            continue;
          }

          var paramObject = param;

          var haveDefaultValue = logger.confirm(
            '${i + 1}. Does this parameter have a default value?: ',
            defaultValue: false,
          );

          if (haveDefaultValue) {
            var defaultValue = logger.prompt(
              '${i + 1}. What is the default value for this param?: ',
            );

            paramObject = {
              ...paramObject,
              'default': defaultValue,
            };
          }

          selectedParams.add(paramObject);
        }
        textStyles.add(
          {
            'name': textStyleName,
            'fontSize': fontSize,
            if (selectedParams.isNotEmpty) 'parameters': selectedParams,
          },
        );
      }

      context.vars = {
        ...context.vars,
        'typography': textStyles,
      };
      logger.info(
        green.wrap('Text styles generated successfully!'),
      );
    }
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
    final oldPackageName = yamlMap['name'];

    if (oldPackageName == null) {
      throw PubspecException();
    }

    var checkTestProgress = logger.progress('Checking for unused files...');
    var libResult = await Process.run(
      'test',
      [
        '-e',
        'lib/$oldPackageName.dart',
      ],
    );

    var testResult = await Process.run(
      'test',
      [
        '-e',
        'test/${oldPackageName}_test.dart',
      ],
    );

    if (libResult.exitCode == 0 || testResult.exitCode == 0) {
      checkTestProgress.complete('Some unused files detected!');

      var removeUnusedFileProgress =
          logger.progress('Removing all unused files...');

      List<Future<ProcessResult>> removalProcesses = [];

      if (libResult.exitCode == 0) {
        removalProcesses.add(Process.run(
          'rm',
          [
            'lib/${oldPackageName}.dart',
          ],
        ));
      }

      if (testResult.exitCode == 0) {
        removalProcesses.add(Process.run(
          'rm',
          [
            'test/${oldPackageName}_test.dart',
          ],
        ));
      }

      var removalResults = await Future.wait(removalProcesses);

      var allRemoved = !removalResults.any((result) => result.exitCode != 0);

      if (allRemoved) {
        removeUnusedFileProgress
            .complete('All unused files successfully removed!');
      } else {
        removeUnusedFileProgress.fail('Failed to remove some unused files!');
      }
    } else {
      checkTestProgress.complete('No unused files detected!');
    }

    context.vars = {
      ...context.vars,
      'packageName': '${(context.vars['name'] as String).snakeCase}_ui_kit',
    };
  } on RangeError catch (_) {
    logger.alert(red.wrap('Could not find the lib folder in $directory'));
    logger.alert(red.wrap('Re-run this brick inside your lib folder'));
    throw Exception();
  } on FileSystemException {
    logger.alert(
      red.wrap(
        'Could not find pubspec.yaml in ${directory.replaceAll('\\lib', '')}',
      ),
    );
  } on PubspecException {
    logger.alert(red.wrap('Could not read the package name in pubspec.yaml'));
  } catch (e) {
    throw e;
  }
}

class PubspecException implements Exception {}
