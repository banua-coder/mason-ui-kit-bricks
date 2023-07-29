import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;

  final fixSyntaxProgress = logger.progress('Clearing all syntax violations');
  try {
    final fixResult = await Process.run('dart', ['fix', '--apply']);
    if (fixResult.exitCode == 0) {
      fixSyntaxProgress.complete('All syntax violations have been fixed!');
      final flutterGetProgress = logger.progress('Running "flutter pub get"');
      try {
        final flutterGetResult = await Process.run('flutter', ['pub', 'get']);
        if (flutterGetResult.exitCode == 0) {
          flutterGetProgress.complete('Flutter packages installed/updated!');
          logger.info('Component generated successfully! Congratulations!');
        } else {
          flutterGetProgress.fail('Flutter packages not installed/updated!');
        }
      } catch (e) {
        flutterGetProgress
            .fail('Error occurred while running "flutter pub get"');
      }
    } else {
      fixSyntaxProgress.fail('All syntax violations could not be fixed!');
    }
  } catch (e) {
    fixSyntaxProgress.fail('Error occurred while running "dart fix --apply"');
  }
}
