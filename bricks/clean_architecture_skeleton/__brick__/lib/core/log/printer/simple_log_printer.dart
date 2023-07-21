import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  SimpleLogPrinter();

  @override
  List<String> log(LogEvent event) {
    var emoji = PrettyPrinter.levelEmojis[event.level];
    return ['$emoji ${event.message}'];
  }
}
