import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';

String getDate(DateTime dateTime) {
  return DateFormat('dd').format(dateTime.toLocal());
}

String getMonth(DateTime dateTime) {
  return DateFormat('MMM').format(dateTime.toLocal());
}

String getYear(DateTime dateTime) {
  return DateFormat('yyyy').format(dateTime.toLocal());
}

String getDayOfWeek(DateTime dateTime) {
  return DateFormat('EEE').format(dateTime.toLocal()).tr;
}

String getTime(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime.toLocal());
}
