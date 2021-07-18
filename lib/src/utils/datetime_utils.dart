import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String getStringDateTimeFromEpoch(String pattern, String date) {
  String newDate = DateFormat(pattern)
      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000));

  return newDate;
}

DateTime getDateTimeFromEpoch(String date) {
  return DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000);
}

String getTimeAgo(String epochtime) {
  String newTimeAgo = timeago
      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(epochtime) * 1000));

  return newTimeAgo;
}
