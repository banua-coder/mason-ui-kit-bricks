import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  var appName = context.vars['name'] as String;
  var organization = context.vars['organization'] as String;
  var failCount = 0;
  var isUsingFvm = false;
  String puroEnv =
      context.vars.containsKey('puroEnv') ? context.vars['puroEnv'] : '';
  Progress? checkPuroProgress;
  Progress? checkFvmProgress;

  try {
    // Check if puro is available
    checkPuroProgress =
        logger.progress('Check if puro installed on the device...');
    var checkPuroResult = await Process.run('puro', []);

    if (checkPuroResult.exitCode == 0 && puroEnv.isNotEmpty) {
      checkPuroProgress.complete('Puro detected on the device!');
      logger.info(blue.wrap('Using puro as Flutter Version Manager!'));
      var setupPuroEnv = logger.progress('Setting up puro env...');
      var setEnvResult = await Process.run('puro', ['use', '-g', puroEnv]);
      setupPuroEnv.complete('Puro env setup successfully!');
      logger.info(blue.wrap(setEnvResult.stdout));
    } else {
      // Check if fvm is available
      checkPuroProgress.fail(
        'Puro is not installed/configured inside the repo!',
      );
      checkFvmProgress =
          logger.progress('Check if fvm installed on the device...');
      var checkFvmResult = await Process.run('fvm', []);

      if (checkFvmResult.exitCode == 0) {
        isUsingFvm = true;
        logger.info(
          blue.wrap(
            'Using fvm as Flutter Version Manager!',
          ),
        );
      } else {
        logger.info(
          blue.wrap(
            'No Flutter version manager detected. Using default Flutter command.',
          ),
        );
      }
    }
  } catch (e) {
    if (checkFvmProgress != null) {
      checkFvmProgress.fail(
        'No Flutter version manager detected. Using default Flutter command.',
      );
    } else {
      logger.err(
        'No Flutter version manager detected. Using default Flutter command.',
      );
    }
  }

  try {
    var versionManager = isUsingFvm ? 'fvm' : 'flutter';
    final updateCommand = {
      'fvm': ['flutter', 'pub', 'upgrade'],
      'flutter': ['pub', 'upgrade']
    }[versionManager];

    final flutterGetProgress = logger.progress('Installing packages');
    var result = await Process.run(
      versionManager,
      updateCommand!,
    );

    if (result.exitCode == 0) {
      flutterGetProgress.complete('Flutter packages installed!');
    } else {
      flutterGetProgress.fail('Failed to install Flutter packages!');
      logger.err(result.stderr);
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
        logger.err(result.stderr);
        failCount++;
      }
    }

    final changeAppNameProgress = logger.progress('Changing app name...');
    result = await Process.run(
      'rename',
      [
        '--targets=ios,android',
        'setAppName',
        '--value=${appName.titleCase}',
      ],
    );

    if (result.exitCode == 0) {
      changeAppNameProgress.complete('App name updated!');
    } else {
      changeAppNameProgress.fail('App name not updated!');
      logger.err(result.stderr);
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
        logger.err(result.stderr);
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
      logger.err(result.stderr);
      failCount++;
    }

    final runBuildRunnerProgress = logger.progress('Running build runner...');
    result = await Process.run('dart', ['run', 'build_runner', 'build', '-d']);

    if (result.exitCode == 0) {
      runBuildRunnerProgress.complete('Build runner executed successfully!');
    } else {
      runBuildRunnerProgress.fail('Build runner failed!');
      logger.err(result.stderr);
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
      logger.err(result.stderr);
      failCount++;
    }

    final formatProgress = logger.progress('Clearing all format violations');

    final formatResult = await Process.run(
      'dart',
      [
        'format',
        'lib',
      ],
    );

    if (formatResult.exitCode == 0) {
      formatProgress.complete(formatResult.stdout);
    } else {
      formatProgress.fail(formatResult.stderr);
      logger.err(result.stderr);
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
      logger.err(result.stderr);
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
      logger.err(result.stderr);
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
