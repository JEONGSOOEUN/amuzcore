import 'package:intl/intl.dart';

String getToday() {
  DateTime now = DateTime. now();
  String formattedDate = DateFormat('yyyy-MM-dd kk:mm'). format(now);
  return formattedDate;
}

