import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  var appName = context.vars['name'] as String;
  var organization = context.vars['organization'] as String;
  var failCount = 0;

  try {
    final flutterGetProgress = logger.progress('Installing packages');
    var result = await Process.run(
      'flutter',
      [
        'pub',
        'upgrade',
      ],
    );

    if (result.exitCode == 0) {
      flutterGetProgress.complete('Flutter packages installed!');
    } else {
      flutterGetProgress.fail('Failed to install Flutter packages!');
      failCount++;
    }

    final checkRenamePackageProgress =
        logger.progress('Checking for rename package');

    result = await Process.run('dart', ['pub', 'global', 'list']);

    if (result.stdout.toString().contains('rename')) {
      checkRenamePackageProgress.complete('Rename package is activated!');
    } else {
      checkRenamePackageProgress.fail('Rename package is not activated!');
      final activateRenameProgress =
          logger.progress('Activating rename package...');
      result = await Process.run(
        'dart',
        ['pub', 'global', 'activate', 'rename'],
      );

      if (result.exitCode == 0) {
        activateRenameProgress.complete('Package rename activated!');
      } else {
        activateRenameProgress.fail('Failed to activate rename package!');
        failCount++;
      }
    }

    final changeAppNameProgress = logger.progress('Changing app name...');
    result = await Process.run(
      'rename',
      [
        'setAppName'
        '--value=${appName.titleCase}',
        '--targets=ios,android',
      ],
    );

    if (result.exitCode == 0) {
      changeAppNameProgress.complete('App name updated!');
    } else {
      changeAppNameProgress.fail('App name not updated!');
      failCount++;
    }

    final checkEnvProgress = logger.progress('Checking if .env is present...');
    result = await Process.run(
      'test',
      [
        '-e',
        '.env',
      ],
    );

    if (result.exitCode != 0) {
      checkEnvProgress.fail('.env not present!');
      final copyingEnvExampleProgress =
          logger.progress('Copying .env.example to .env');
      result = await Process.run(
        'cp',
        [
          '.env.example',
          '.env',
        ],
      );

      if (result.exitCode != 0) {
        copyingEnvExampleProgress.fail(
          'Failed to create .env file. Make sure you have .env or .env.example in the root directory before continuing the process!',
        );
        failCount++;
      } else {
        copyingEnvExampleProgress.complete('.env generated!');
      }
    } else {
      checkEnvProgress.complete('.env file exists!');
    }

    final changeAppPackageProgress =
        logger.progress('Changing app package name and bundle id...');
    result = await Process.run('dart', [
      'run',
      'change_app_package_name:main',
      'com.${organization.snakeCase}.${appName.snakeCase}.app',
    ]);

    if (result.exitCode == 0) {
      changeAppPackageProgress.complete('Bundle id and package name updated!');
    } else {
      changeAppPackageProgress.fail('Bundle id and package name not updated!');
      failCount++;
    }

    final runBuildRunnerProgress = logger.progress('Running build runner...');
    result = await Process.run('dart', ['run', 'build_runner', 'build', '-d']);

    if (result.exitCode == 0) {
      runBuildRunnerProgress.complete('Build runner executed successfully!');
    } else {
      runBuildRunnerProgress.fail('Build runner failed!');
      failCount++;
    }

    final runLauncherIconsProgress =
        logger.progress('Generating launcher icons...');
    result = await Process.run(
      'dart',
      [
        'run',
        'flutter_launcher_icons',
      ],
    );

    if (result.exitCode == 0) {
      runLauncherIconsProgress
          .complete('Launcher icons successfully generated!');
    } else {
      runLauncherIconsProgress.fail('Launcher icons not generated!');
      failCount++;
    }

    final fixSyntaxProgress =
        logger.progress('Clearing all syntax violations...');
    result = await Process.run('dart', [
      'fix',
      '--apply',
    ]);

    if (result.exitCode == 0) {
      fixSyntaxProgress.complete('All syntax violations have been fixed!');
    } else {
      fixSyntaxProgress.fail('All syntax violations could not be fixed!');
      failCount++;
    }

    final removeUnusedFileProgress =
        logger.progress('Removing unused files...');
    result = await Process.run(
      'test',
      [
        '-e',
        'test/widget_test.dart',
      ],
    );

    if (result.exitCode == 0) {
      removeUnusedFileProgress.complete('All unused files have been removed!');
    } else {
      removeUnusedFileProgress.fail('All unused files have not been removed!');
      failCount++;
    }

    if (failCount > 0) {
      logger.warn(
          'Some tasks were not executed successfully. Please check your config and code before you can re-run the process!');
    } else {
      logger.success(
          'Flutter project skeleton generated successfully! Let\'s build something awesome!');
    }
  } catch (e) {
    logger.alert('An error occurred: $e');
    failCount++;
  }
}
