import 'package:get/get.dart';

String convertToKhmerDate(DateTime dateTime) {
  List<String> khmerMonths = [
    'មករា',
    'កុម្ភៈ',
    'មីនា',
    'មេសា',
    'ឧសភា',
    'មិថុនា',
    'កក្កដា',
    'សីហា',
    'កញ្ញា',
    'តុលា',
    'វិច្ឆិកា',
    'ធ្នូ'
  ];

  var date = dateTime.toLocal();
  String khmerMonth = khmerMonths[date.month - 1];

  String formattedDate = '${date.day} $khmerMonth ${date.year}';

  return formattedDate;
}

String convertToKhmerTimeAgo(DateTime targetDate) {
  DateTime now = DateTime.now();
  Duration diff = now.difference(targetDate);

  int dayDiff = diff.inDays;
  if (dayDiff == 0) {
    if (diff.inSeconds < 60) {
      return 'just now'.tr;
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${'minutes ago'.tr}';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} ${'hours ago'.tr}';
    }
  } else if (dayDiff == 1) {
    return 'yesterday'.tr;
  } else if (dayDiff < 7) {
    return '$dayDiff ${'days ago'.tr}';
  } else if (dayDiff == 7) {
    return '1 ${'week ago'.tr}';
  } else if (dayDiff < 31) {
    int weeks = (dayDiff / 7).ceil();
    return '$weeks ${'weeks ago'.tr}';
  } else if (dayDiff < 365) {
    int months = (dayDiff / 30).ceil();
    return '$months ${'months ago'.tr}';
  } else {
    int years = (dayDiff / 365).ceil();
    return '$years ${'years ago'.tr}';
  }
  return '';
}
