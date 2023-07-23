import 'dart:io';

import 'package:mason/mason.dart';
import 'package:recase/recase.dart';

void run(HookContext context) async {
  var appName = ReCase(context.vars['name']);
  var failCount = 0;

  final pubGetProgress =
      context.logger.progress('Installing & updating packages!');

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
    pubGetProgress.fail('Flutter packages not installed/updated!');
    failCount++;
  }

  String currentDirectory = Directory.current.path;
  String desiredDirectory = 'example';
  String newPath =
      '${currentDirectory}${Platform.pathSeparator}${desiredDirectory}';

  Directory.current = newPath;

  var flutterCreateProgress = context.logger.progress(
    'Fixing example project!',
  );

  result = await Process.run('flutter', ['create', '.']);

  var isProjectFixed = false;

  if (result.exitCode == 0) {
    isProjectFixed = true;
    flutterCreateProgress.complete('Successfully fixing example project!');
  } else {
    flutterCreateProgress.fail('Failed to fix example project!');
    failCount++;
  }

  result = await Process.run(
    'rm',
    [
      'test/widget_test.dart',
    ],
  );

  final removeUnusedFileProgress =
      context.logger.progress('Remove unused file!');

  if (result.exitCode == 0) {
    removeUnusedFileProgress.complete('All unused file has been removed!');
  } else {
    removeUnusedFileProgress.fail('All unused file has not been removed!');

    failCount++;
  }

  if (isProjectFixed) {
    var installedExamplePackage = context.logger.progress(
      'Installed package for example project!',
    );

    result = await Process.run('flutter', ['pub', 'upgrade']);

    if (result.exitCode == 0) {
      installedExamplePackage
          .complete('Successfully update package of example project!');
    } else {
      installedExamplePackage.complete(
        'Failed to update package of example project!',
      );
      failCount++;
    }

    final changeBundleIdProgress =
        context.logger.progress('Change app package name and bundle id');
    result = await Process.run('dart', [
      'run',
      'change_app_package_name:main',
      'com.${appName.snakeCase}_ui_kit.example.app',
    ]);

    if (result.exitCode == 0) {
      changeBundleIdProgress.complete('Bundle id and package name updated!');
    } else {
      changeBundleIdProgress.fail('Bundle id and package name not updated!');
      failCount++;
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
        '--appname=${appName.titleCase} UI Kit',
        '--target=ios,android',
      ],
    );

    if (result.exitCode == 0) {
      changeAppNameProgress.complete('App name updated!');
    } else {
      changeAppNameProgress.fail('App name not updated!');
    }
  } else {
    context.logger.warn(
      'Some step are skipped because example project not fixed!',
    );
  }

  if (failCount == 0) {
    context.logger.success(
      'Successfuly generated core of your UI Kit package! Let`s built some beautiful components!',
    );
  } else {
    context.logger.warn(
      'Some step are skipped because example project does not exist!',
    );
  }
}
