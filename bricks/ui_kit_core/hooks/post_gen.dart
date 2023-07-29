import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  var packageName = context.vars['packageName'] as String;
  var failCount = 0;

  final pubGetProgress =
      context.logger.progress('Installing & updating packages...');

  var result = await Process.run(
    'flutter',
    [
      'pub',
      'upgrade',
    ],
  );

  if (result.exitCode == 0) {
    pubGetProgress.complete('Flutter packages installed/updated!');
  } else {
    pubGetProgress.fail('Failed to install/update Flutter packages!');
    failCount++;
  }

  String currentDirectory = Directory.current.path;
  String desiredDirectory = 'example';
  String newPath =
      '${currentDirectory}${Platform.pathSeparator}${desiredDirectory}';

  Directory.current = newPath;

  var flutterCreateProgress = context.logger.progress(
    'Fixing the example project...',
  );

  result = await Process.run('flutter', ['create', '.']);

  var isProjectFixed = false;

  if (result.exitCode == 0) {
    isProjectFixed = true;
    flutterCreateProgress.complete('Successfully fixed the example project!');
  } else {
    flutterCreateProgress.fail('Failed to fix the example project!');
    failCount++;
  }

  result = await Process.run(
    'rm',
    [
      'test/widget_test.dart',
    ],
  );

  final removeUnusedFileProgress =
      context.logger.progress('Removing unused files...');

  if (result.exitCode == 0) {
    removeUnusedFileProgress.complete('All unused files have been removed!');
  } else {
    removeUnusedFileProgress.fail('Failed to remove all unused files!');
    failCount++;
  }

  if (isProjectFixed) {
    var installedExamplePackage = context.logger.progress(
      'Installing packages for the example project...',
    );

    result = await Process.run('flutter', ['pub', 'upgrade']);

    if (result.exitCode == 0) {
      installedExamplePackage
          .complete('Successfully updated packages for the example project!');
    } else {
      installedExamplePackage.complete(
        'Failed to update packages for the example project!',
      );
      failCount++;
    }

    final changeBundleIdProgress =
        context.logger.progress('Changing app package name and bundle id...');
    result = await Process.run('dart', [
      'run',
      'change_app_package_name:main',
      'com.$packageName.example.app',
    ]);

    if (result.exitCode == 0) {
      changeBundleIdProgress.complete('Bundle id and package name updated!');
    } else {
      changeBundleIdProgress
          .fail('Failed to update bundle id and package name!');
      failCount++;
    }

    final checkRenamePackageProgress =
        context.logger.progress('Checking for rename package...');

    result = await Process.run('dart', ['pub', 'global', 'list']);

    if (result.stdout.toString().contains('rename')) {
      checkRenamePackageProgress.complete('Rename package is active!');
    } else {
      checkRenamePackageProgress.fail('Rename package is not activated!');
      final activateRenameProgress =
          context.logger.progress('Activating rename package...');
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

    final changeAppNameProgress =
        context.logger.progress('Changing app name...');
    result = await Process.run(
      'rename',
      [
        '--appname=${packageName.titleCase}',
        '--target=ios,android',
      ],
    );

    if (result.exitCode == 0) {
      changeAppNameProgress.complete('App name updated!');
    } else {
      changeAppNameProgress.fail('App name not updated!');
      failCount++;
    }
  } else {
    context.logger.warn(
      'Some steps are skipped because the example project is not fixed!',
    );
  }

  currentDirectory = Directory.current.path;
  desiredDirectory =
      currentDirectory.replaceAll('${Platform.pathSeparator}example', '');
  newPath = desiredDirectory;

  Directory.current = newPath;

  // Fix code violations
  final fixSyntaxProgress =
      context.logger.progress('Clearing all syntax violations');
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

  // Rename example config files
  final renameExampleConfigProgress =
      context.logger.progress('Renaming example config files...');
  try {
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
  } catch (e) {
    renameExampleConfigProgress
        .fail('Error occurred while renaming example config files');
    failCount++;
  }

  if (failCount == 0) {
    context.logger.success(
      'Successfully generated the core of your UI Kit package! Let\'s build some beautiful components!',
    );
    context.logger.info(
        'You can use "component-config.json" to customize the component according to your needs.');
    context.logger.info(
        'To generate the component using the UI Kit component brick, run this command:');
    context.logger.info('mason make ui_kit_component -c component-config.json');
  } else {
    context.logger.warn(
      'Some steps encountered errors or were skipped. Please check your config and code before proceeding!',
    );
  }
}
