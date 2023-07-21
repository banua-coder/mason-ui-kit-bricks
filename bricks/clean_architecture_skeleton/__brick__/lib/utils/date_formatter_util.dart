import 'package:intl/intl.dart';

class DateFormatterUtil {
  const DateFormatterUtil._();

  static const DateFormatterUtil _instance = DateFormatterUtil._();

  factory DateFormatterUtil() {
    return _instance;
  }

  static String formatDate(
    String format,
    DateTime? date, [
    bool showTimezone = false,
  ]) {
    if (date == null) {
      return '';
    }
    var formatted = DateFormat(
      format,
      'id_ID',
    ).format(date);

    if (!showTimezone) {
      return formatted;
    }

    return '$formatted ${date.timeZoneName}';
  }
}
