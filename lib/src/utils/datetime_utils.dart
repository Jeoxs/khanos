import 'package:intl/intl.dart';

String getStringDateTimeFromEpoch(String pattern, String date) {
  String newDate = DateFormat(pattern)
      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000));

  return newDate;
}

DateTime getDateTimeFromEpoch(String date) {
  return DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000);
}
