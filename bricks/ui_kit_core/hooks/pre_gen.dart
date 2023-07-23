import 'dart:io';

import 'package:mason/mason.dart';
import 'package:recase/recase.dart';

void run(HookContext context) async {
  var appName = ReCase(context.vars['name']);

  var checkTestProgress = context.logger.progress('Check for unused file!');
  var result = await Process.run('test', [
    '-e',
    'test/${appName.snakeCase}_ui_kit_test.dart',
  ]);

  if (result.exitCode == 0) {
    checkTestProgress.complete('Some unused file detected!');

    var removeUnusedFileProgress =
        context.logger.progress('Removing all unused file!');
    result = await Process.run(
      'rm',
      [
        'test/${appName.snakeCase}_ui_kit_test.dart',
      ],
    );

    if (result.exitCode == 0) {
      removeUnusedFileProgress
          .complete('All unused file successfully removed!');
    } else {
      removeUnusedFileProgress.fail('Failed to remove some unused file!');
    }
  } else {
    checkTestProgress.complete('There are no unused file detected!');
  }
}
