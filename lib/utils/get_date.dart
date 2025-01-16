DateTime getDateOnly(DateTime dateTime) {
  final date = dateTime.toLocal(); // Ensure it's in the local timezone
  return DateTime(date.year, date.month, date.day);
}
