String formatDateTime(DateTime dateTime) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String day = twoDigits(dateTime.day);
  String month = twoDigits(dateTime.month);
  String year = dateTime.year.toString().substring(2); // Get last 2 digits
  int hour = dateTime.hour;
  String minute = twoDigits(dateTime.minute);

  String period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour;

  return '$day-$month-$year at $hour:$minute $period';
}
