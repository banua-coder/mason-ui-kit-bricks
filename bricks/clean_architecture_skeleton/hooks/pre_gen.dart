import 'dart:convert';
import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  var name = context.vars['name'] as String;

  try {
    final assetsDirectoryProcess =
        logger.progress('Checking if the assets directory exists...');
    var result = await Process.run(
      'ls',
      ['assets'],
    );

    if (result.exitCode != 0) {
      assetsDirectoryProcess.fail(
        'You must create the "assets/logo" directory and add all its assets first!',
      );
      exit(1);
    } else {
      assetsDirectoryProcess.complete(
        'Assets directory exists!',
      );
    }

    final launcherIconProcess =
        logger.progress('Checking if the logo for the launcher icon exists...');
    result = await Process.run(
      'test',
      [
        '-e',
        'assets/logo/${name.snakeCase}_icons.png',
      ],
    );

    if (result.exitCode != 0) {
      launcherIconProcess.fail(
        'You must create a launcher icon with the name "${name.snakeCase}_icons.png" in the "assets/logo" directory before continuing the process!',
      );
      exit(1);
    } else {
      launcherIconProcess.complete(
        'Launcher icon exists!',
      );
    }

    final directory = '${Directory.current.path}${Platform.pathSeparator}lib';
    List<String> folders = directory.split(Platform.pathSeparator).toList();

    final libIndex = folders.indexWhere((folder) => folder == 'lib');

    final puroFile = File(
      '${folders.sublist(0, libIndex).join(Platform.pathSeparator)}/.puro.json',
    );

    if (puroFile.existsSync()) {
      var puroContent = await puroFile.readAsString();
      var puroJson = jsonDecode(puroContent);
      var puroEnv = puroJson['env'];
      context.vars = {
        ...context.vars,
        'puroEnv': puroEnv,
      };
    }
  } catch (e) {
    logger.err(e.toString());
  }
}
