import 'dart:io';
import 'package:mason/mason.dart';
import 'package:recase/recase.dart';

void run(HookContext context) async {
  var name = ReCase(context.vars['name']);
  var process = context.logger.progress('Check if assets directory is exist!');
  var result = await Process.run(
    'ls',
    ['assets'],
  );

  if (result.exitCode != 0) {
    process.fail(
      'You must create "assets/logo" directory and all it`s assets first!',
    );
    exit(1);
  } else {
    process.complete(
      'Assets directory exist!',
    );
  }

  var process2 =
      context.logger.progress('Check if logo for launcher icon is exist!');
  result = await Process.run(
    'test',
    [
      '-e',
      'assets/logo/${name.snakeCase}_icons.png',
    ],
  );

  if (result.exitCode != 0) {
    process2.fail(
      'You must create launcher icon with name "${name.snakeCase}_icons.png" in "assets/logo" directory before continuing the process!',
    );
    exit(1);
  } else {
    process2.complete(
      'Launcher icon exists!',
    );
  }
}
