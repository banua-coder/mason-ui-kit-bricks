extension NumExtension on num {
  Duration get days => Duration(days: toInt());
  Duration get hours => Duration(hours: toInt());
  Duration get microseconds => Duration(microseconds: toInt());
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get seconds => Duration(seconds: toInt());
}
