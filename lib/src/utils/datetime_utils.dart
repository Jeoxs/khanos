import 'package:intl/intl.dart';

String getDateTimeFromEpoch(String pattern, String date) {
  String newDate = DateFormat(pattern)
      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000));

  return newDate;
}
