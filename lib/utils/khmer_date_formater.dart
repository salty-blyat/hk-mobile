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
    'តុលា',
    'វិច្ឆិកា',
    'ធ្នូ',
    'ធ្នូ'
  ];

  // Get the Khmer month name
  String khmerMonth = khmerMonths[dateTime.month - 1];

  // Format the date
  String formattedDate = '${dateTime.day} $khmerMonth ${dateTime.year}';

  return formattedDate;
}

String convertToKhmerTimeAgo(DateTime targetDate, String lang) {
  DateTime now = DateTime.now();
  Duration diff = now.difference(targetDate);

  int dayDiff = diff.inDays;
  if (dayDiff == 0) {
    if (diff.inSeconds < 60) {
      return lang == 'en' ? 'just now' : 'ឥឡូវនេះ';
    } else if (diff.inMinutes < 60) {
      return lang == 'en'
          ? '${diff.inMinutes} minutes ago'
          : '${diff.inMinutes} នាទីមុន';
    } else if (diff.inHours < 24) {
      return lang == 'en'
          ? '${diff.inHours} hours ago'
          : '${diff.inHours} ម៉ោងមុន';
    }
  } else if (dayDiff == 1) {
    return lang == 'en' ? 'Yesterday' : 'ម្សិលមិញ';
  } else if (dayDiff < 7) {
    return lang == 'en' ? '$dayDiff days ago' : '$dayDiff ថ្ងៃមុន';
  } else if (dayDiff == 7) {
    return lang == 'en' ? '1 week ago' : '1 សប្តាហ៍មុន';
  } else if (dayDiff < 31) {
    int weeks = (dayDiff / 7).ceil();
    return lang == 'en' ? '$weeks weeks ago' : '$weeks សប្តាហ៍មុន';
  } else if (dayDiff < 365) {
    int months = (dayDiff / 30).ceil();
    return lang == 'en' ? '$months months ago' : '$months ខែមុន';
  } else {
    int years = (dayDiff / 365).ceil();
    return lang == 'en' ? '$years year ago' : '$years ឆ្នាំមុន';
  }
  return '';
}
