import 'dart:io';
import 'package:recase/recase.dart';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  var appName = ReCase(context.vars['name']);
  var organization = ReCase(context.vars['organization']);
  var failCount = 0;

  final progress = context.logger.progress('Installing packages');
  var result = await Process.run(
    'flutter',
    [
      'pub',
      'upgrade',
    ],
  );

  if (result.exitCode == 0) {
    progress.complete('Flutter packages installed!');
  } else {
    progress.fail('Flutter packages not installed!');
    failCount++;
  }

  final progress2 = context.logger.progress('Change app name');
  result = await Process.run('rename', [
    '--appname=${appName.titleCase}',
    '--target=ios,android',
  ]);

  if (result.exitCode == 0) {
    progress2.complete('App name updated!');
  } else {
    progress2.fail('App name not updated!');
    failCount++;
  }

  final progress3 =
      context.logger.progress('Change app package name and bundle id');
  result = await Process.run('dart', [
    'run',
    'change_app_package_name:main',
    'com.${organization.snakeCase}.${appName.snakeCase}.app',
  ]);

  if (result.exitCode == 0) {
    progress3.complete('Bundle id and package name updated!');
  } else {
    progress3.fail('Bundle id and package name not updated!');
    failCount++;
  }

  var process8 = context.logger.progress('Check if .env is present!');
  result = await Process.run(
    'test',
    [
      '-e',
      '.env',
    ],
  );

  if (result.exitCode != 0) {
    process8.fail(
      '.env not present!',
    );
    var process9 = context.logger.progress('Copying .env.example to .env');
    result = await Process.run(
      'cp',
      [
        '.env.example',
        '.env',
      ],
    );

    if (result.exitCode != 0) {
      process9.fail(
        'Failed crete .env file. Make sure you have .env or .env.example in root directory before continuing the process!',
      );
      failCount++;
    } else {
      process9.complete(
        '.env generated!',
      );
    }
  } else {
    process8.complete(
      '.env file exists!',
    );
  }

  final progress5 = context.logger.progress('Run build runner');
  result = await Process.run('dart', ['run', 'build_runner', 'build', '-d']);

  if (result.exitCode == 0) {
    progress5.complete(
      'Build runner executed successfully!',
    );
  } else {
    progress5.fail(
      'Build runner failed!',
    );
    failCount++;
  }

  final progress7 = context.logger.progress('Generating launcher icons!');
  result = await Process.run(
    'dart',
    [
      'run',
      'flutter_launcher_icons',
    ],
  );

  if (result.exitCode == 0) {
    progress7.complete('Launcher icons successfully generated!');
  } else {
    progress7.fail('Launcher icons not generated!');
    failCount++;
  }

  final progress4 = context.logger.progress('Clearing all syntax violation');
  result = await Process.run('dart', [
    'fix',
    '--apply',
  ]);

  if (result.exitCode == 0) {
    progress4.complete('All syntax violation has been fixed!');
  } else {
    progress4.fail('All syntax violation can not be fixed!');
    failCount++;
  }

  result = await Process.run(
    'test',
    [
      '-e',
      'test/widget_test.dart',
    ],
  );

  if (result.exitCode != 0) {
    final progress6 = context.logger.progress('Remove unused file!');
    result = await Process.run(
      'rm',
      [
        'test/widget_test.dart',
      ],
    );

    if (result.exitCode == 0) {
      progress6.complete('All unused file has been removed!');
    } else {
      progress6.fail('All unused file has not been removed!');

      failCount++;
    }
  }

  if (failCount > 0) {
    context.logger.warn(
      'Some of the task are not successfully executed. Please check your config and code before you can re-run the process!',
    );
  } else {
    context.logger.success(
      'Flutter project skeleton generated successfuly! Let`s built something awesome!',
    );
  }
}
