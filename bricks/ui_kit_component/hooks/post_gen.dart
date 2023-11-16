import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  var isUsingFvm = false;
  String puroEnv =
      context.vars.containsKey('puroEnv') ? context.vars['puroEnv'] : '';

  try {
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
    }

    final fixSyntaxProgress = logger.progress('Clearing all syntax violations');
    final fixResult = await Process.run('dart', ['fix', '--apply']);
    if (fixResult.exitCode == 0) {
      fixSyntaxProgress.complete('All syntax violations have been fixed!');
    } else {
      fixSyntaxProgress.fail('All syntax violations could not be fixed!');
      logger.err(fixResult.stderr);
    }
  } catch (e) {
    logger.err(e.toString());
  }

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
      checkPuroProgress.fail(
        'Puro is not installed/configured inside the repo!',
      );
      checkFvmProgress =
          logger.progress('Check if fvm installed on the device...');

      var checkFvmResult = await Process.run('fvm', []);

      if (checkFvmResult.exitCode == 0) {
        checkFvmProgress.complete('fvm detected on the device!');
        isUsingFvm = true;
        logger.info(
          blue.wrap(
            'Using fvm as Flutter Version Manager!',
          ),
        );
      } else {
        checkFvmProgress.complete(
          yellow.wrap('fvm not installed on the device!'),
        );
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

    final flutterGetProgress = logger.progress('Running "flutter pub get"');

    final flutterGetCommand = {
      'fvm': ['flutter', 'pub', 'get'],
      'flutter': ['pub', 'get'],
    }[versionManager];

    final flutterGetResult = await Process.run(
      versionManager,
      flutterGetCommand!,
    );
    if (flutterGetResult.exitCode == 0) {
      flutterGetProgress.complete('Flutter packages installed/updated!');
      logger.info('Component generated successfully! Congratulations!');
    } else {
      flutterGetProgress.fail('Flutter packages not installed/updated!');
      logger.err(flutterGetResult.stderr);
    }

    if (puroEnv.isNotEmpty) {
      var setupPuroEnv = logger.progress('Using stable puro env...');
      var setEnvResult = await Process.run('puro', ['use', '-g', 'stable']);
      setupPuroEnv.complete('Puro env reset successfully!');
      logger.info(blue.wrap(setEnvResult.stdout));
    }
  } catch (e) {
    logger.err(e.toString());
  }
}
