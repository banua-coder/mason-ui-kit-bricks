import 'dart:io';
import 'package:recase/recase.dart';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  var appName = ReCase(context.vars['name']);
  var organization = ReCase(context.vars['organization']);
  var failCount = 0;

  var isPubGetFailed = false;

  final flutterGetProgress = context.logger.progress('Installing packages');
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
    flutterGetProgress.fail('Flutter packages not installed!');
    failCount++;
    isPubGetFailed = true;
  }

  final checkRenamePackageProgress =
      context.logger.progress('Check for rename package');

  result = await Process.run('dart', ['pub', 'global', 'list']);

  if (result.stdout.toString().contains('rename')) {
    checkRenamePackageProgress.complete('Rename package activated!');
  } else {
    checkRenamePackageProgress.fail('Rename package does not activated!');
    final activateRenameProgress =
        context.logger.progress('Activate rename package!');
    result = await Process.run(
      'dart',
      ['pub', 'global', 'activate', 'rename'],
    );

    if (result.exitCode == 0) {
      activateRenameProgress.complete('Package rename activated!');
    } else {
      activateRenameProgress.fail('Fail to activate rename package!');
      failCount++;
    }
  }

  final changeAppNameProgress = context.logger.progress('Change app name');
  result = await Process.run(
    'rename',
    [
      '--appname=${appName.titleCase}',
      '--target=ios,android',
    ],
  );

  if (result.exitCode == 0) {
    changeAppNameProgress.complete('App name updated!');
  } else {
    changeAppNameProgress.fail('App name not updated!');
  }

  if (isPubGetFailed) {
    context.logger.warn('Skip change bundle id step!');
  } else {
    final changeBundleIdProgress =
        context.logger.progress('Change app package name and bundle id');
    result = await Process.run('dart', [
      'run',
      'change_app_package_name:main',
      'com.${organization.snakeCase}.${appName.snakeCase}.app',
    ]);

    if (result.exitCode == 0) {
      changeBundleIdProgress.complete('Bundle id and package name updated!');
    } else {
      changeBundleIdProgress.fail('Bundle id and package name not updated!');
      failCount++;
    }
  }

  var checkEnvProgress = context.logger.progress('Check if .env is present!');
  result = await Process.run(
    'test',
    [
      '-e',
      '.env',
    ],
  );

  if (result.exitCode != 0) {
    checkEnvProgress.fail(
      '.env not present!',
    );
    var copyingEnvExampleProgress =
        context.logger.progress('Copying .env.example to .env');
    result = await Process.run(
      'cp',
      [
        '.env.example',
        '.env',
      ],
    );

    if (result.exitCode != 0) {
      copyingEnvExampleProgress.fail(
        'Failed crete .env file. Make sure you have .env or .env.example in root directory before continuing the process!',
      );
      failCount++;
    } else {
      copyingEnvExampleProgress.complete(
        '.env generated!',
      );
    }
  } else {
    checkEnvProgress.complete(
      '.env file exists!',
    );
  }

  if (isPubGetFailed) {
    context.logger.warn('Skip build runner step!');
  } else {
    final runBuildRunnerProgress = context.logger.progress('Run build runner');
    result = await Process.run('dart', ['run', 'build_runner', 'build', '-d']);

    if (result.exitCode == 0) {
      runBuildRunnerProgress.complete(
        'Build runner executed successfully!',
      );
    } else {
      runBuildRunnerProgress.fail(
        'Build runner failed!',
      );
      failCount++;
    }
  }

  if (isPubGetFailed) {
    context.logger.warn('Skip launcher icons generator step!');
  } else {
    final runLauncherIconsProgress =
        context.logger.progress('Generating launcher icons!');
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
  }

  final fixSyntaxProgress =
      context.logger.progress('Clearing all syntax violation');
  result = await Process.run('dart', [
    'fix',
    '--apply',
  ]);

  if (result.exitCode == 0) {
    fixSyntaxProgress.complete('All syntax violation has been fixed!');
  } else {
    fixSyntaxProgress.fail('All syntax violation can not be fixed!');
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
    final removeUnusedFileProgress =
        context.logger.progress('Remove unused file!');
    result = await Process.run(
      'rm',
      [
        'test/widget_test.dart',
      ],
    );

    if (result.exitCode == 0) {
      removeUnusedFileProgress.complete('All unused file has been removed!');
    } else {
      removeUnusedFileProgress.fail('All unused file has not been removed!');

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
