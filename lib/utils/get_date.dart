import 'package:intl/intl.dart';

DateTime getDateOnly(DateTime dateTime) {
  final date = dateTime.toLocal(); // Ensure it's in the local timezone
  return DateTime(date.year, date.month, date.day);
}

String getDateOnlyString(DateTime dateTime) {
  final date = dateTime.toLocal();
  return DateFormat('yyyy-MM-dd').format(date);
}
