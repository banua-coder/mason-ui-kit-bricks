import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  var packageName = context.vars['packageName'] as String;
  var failCount = 0;
  var isUsingFvm = false;
  String puroEnv =
      context.vars.containsKey('puroEnv') ? context.vars['puroEnv'] : '';
  Progress? renameExampleConfigProgress;
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
    var flutterCommand =
        versionManager == 'flutter' ? ['--version'] : ['flutter', '--version'];

    var checkVersionResult = await Process.run(versionManager, flutterCommand);
    logger.info(blue.wrap(checkVersionResult.stdout));

    final pubGetProgress = logger.progress('Installing & updating packages...');

    final updateCommand = {
      'fvm': ['flutter', 'pub', 'upgrade'],
      'flutter': ['pub', 'upgrade']
    }[versionManager];

    var result = await Process.run(
      versionManager,
      updateCommand!,
    );

    if (result.exitCode == 0) {
      pubGetProgress.complete('Flutter packages installed/updated!');
    } else {
      pubGetProgress.fail('Failed to install/update Flutter packages!');
      logger.err(result.stderr);
      failCount++;
    }

    String currentDirectory = Directory.current.path;
    String desiredDirectory = 'example';
    String newPath =
        '${currentDirectory}${Platform.pathSeparator}${desiredDirectory}';

    Directory.current = newPath;

    var flutterCreateProgress = logger.progress(
      'Fixing the example project...',
    );

    var flutterCreateCommand = {
      'fvm': ['flutter', 'create', '.'],
      'flutter': ['create', '.'],
    }[versionManager];

    result = await Process.run(versionManager, flutterCreateCommand!);

    var isProjectFixed = false;

    if (result.exitCode == 0) {
      isProjectFixed = true;
      flutterCreateProgress.complete('Successfully fixed the example project!');
    } else {
      flutterCreateProgress.fail('Failed to fix the example project!');
      logger.err(result.stderr);
      failCount++;
    }

    result = await Process.run(
      'rm',
      [
        'test/widget_test.dart',
      ],
    );

    final removeUnusedFileProgress =
        logger.progress('Removing unused files...');

    if (result.exitCode == 0) {
      removeUnusedFileProgress.complete('All unused files have been removed!');
    } else {
      removeUnusedFileProgress.fail('Failed to remove all unused files!');
      logger.err(result.stderr);
      failCount++;
    }

    if (isProjectFixed) {
      var installedExamplePackage = logger.progress(
        'Installing packages for the example project...',
      );

      result = await Process.run(versionManager, updateCommand);

      if (result.exitCode == 0) {
        installedExamplePackage
            .complete('Successfully updated packages for the example project!');
      } else {
        installedExamplePackage.complete(
          'Failed to update packages for the example project!',
        );
        logger.err(result.stderr);
        failCount++;
      }

      final changeBundleIdProgress =
          logger.progress('Changing app package name and bundle id...');
      result = await Process.run(
        'dart',
        [
          'run',
          'change_app_package_name:main',
          'com.$packageName.example.app',
        ],
      );

      if (result.exitCode == 0) {
        changeBundleIdProgress.complete('Bundle id and package name updated!');
      } else {
        changeBundleIdProgress
            .fail('Failed to update bundle id and package name!');
        logger.err(result.stderr);
        failCount++;
      }

      final checkRenamePackageProgress =
          logger.progress('Checking for rename package...');

      result = await Process.run('dart', ['pub', 'global', 'list']);

      if (result.stdout.toString().contains('rename')) {
        checkRenamePackageProgress.complete('Rename package is active!');
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
          'setAppName',
          '--target=ios,android',
          '--value-"${packageName.titleCase}"'
        ],
      );

      if (result.exitCode == 0) {
        changeAppNameProgress.complete('App name updated!');
      } else {
        changeAppNameProgress.fail('App name not updated!');
        logger.err(result.stderr);
        failCount++;
      }
    } else {
      logger.warn(
        'Some steps are skipped because the example project is not fixed!',
      );
    }

    currentDirectory = Directory.current.path;
    desiredDirectory =
        currentDirectory.replaceAll('${Platform.pathSeparator}example', '');
    newPath = desiredDirectory;

    Directory.current = newPath;

    // Fix code violations
    final fixSyntaxProgress = logger.progress('Clearing all syntax violations');
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

    // Rename example config files
    renameExampleConfigProgress =
        logger.progress('Renaming example config files...');
    final exampleCoreConfigFile = File('example-core-config.json');
    final exampleComponentConfigFile = File('example-component-config.json');
    final newCoreConfigFile = File('core-config.json');
    final newComponentConfigFile = File('component-config.json');

    if (await newComponentConfigFile.exists()) {
      await exampleComponentConfigFile.delete();
    } else {
      await exampleComponentConfigFile.rename(newComponentConfigFile.path);
    }

    if (await newCoreConfigFile.exists()) {
      await exampleCoreConfigFile.delete();
    } else {
      await exampleCoreConfigFile.rename(newCoreConfigFile.path);
    }

    renameExampleConfigProgress
        .complete('Example config files renamed successfully!');

    if (puroEnv.isNotEmpty) {
      var setupPuroEnv = logger.progress('Using stable puro env...');
      var setEnvResult = await Process.run('puro', ['use', '-g', 'stable']);
      setupPuroEnv.complete('Puro env reset successfully!');
      logger.info(blue.wrap(setEnvResult.stdout));
    }
  } catch (e) {
    if (renameExampleConfigProgress != null) {
      renameExampleConfigProgress
          .fail('Error occurred while renaming example config files');
    } else {
      logger.err(e.toString());
    }
    failCount++;
  }

  if (failCount == 0) {
    logger.success(
      'Successfully generated the core of your UI Kit package! Let\'s build some beautiful components!',
    );
    logger.info(
        'You can use "component-config.json" to customize the component according to your needs.');
    logger.info(
        'To generate the component using the UI Kit component brick, run this command:');
    logger.info('mason make ui_kit_component -c component-config.json');
  } else {
    logger.warn(
      'Some steps encountered errors or were skipped. Please check your config and code before proceeding!',
    );
  }
}
