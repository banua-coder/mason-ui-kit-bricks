import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  var isUsingFvm = false;
  var puroEnv =
      context.vars.containsKey('puroEnv') ? context.vars['puroEnv'] : '';

  final fixSyntaxProgress = logger.progress('Clearing all syntax violations');
  try {
    final fixResult = await Process.run('dart', ['fix', '--apply']);
    if (fixResult.exitCode == 0) {
      fixSyntaxProgress.complete('All syntax violations have been fixed!');

      // Check if puro is available
      var checkPuroResult = await Process.run('puro', []);

      if (checkPuroResult.exitCode == 0) {
        logger.info(blue.wrap('Using puro as Flutter Version Manager!'));
        var setupPuroEnv = logger.progress('Setting up puro env...');
        var setEnvResult = await Process.run('puro', ['use', '-g', puroEnv]);
        setupPuroEnv.complete('Puro env setup successfully!');
        logger.info(blue.wrap(setEnvResult.stdout));
      } else {
        // Check if fvm is available
        var checkFvmResult = await Process.run('fvm', ['flutter', '--version']);

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
      }
    } else {
      fixSyntaxProgress.fail('All syntax violations could not be fixed!');
    }

    var setupPuroEnv = logger.progress('Using stable puro env...');
    var setEnvResult = await Process.run('puro', ['use', '-g', 'stable']);
    setupPuroEnv.complete('Puro env reset successfully!');
    logger.info(blue.wrap(setEnvResult.stdout));
  } catch (e) {
    fixSyntaxProgress.fail('Error occurred while running "dart fix --apply"');
  }
}
