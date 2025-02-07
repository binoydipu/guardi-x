DateTime mergeDateTime(String dateOfCrime, String timeOfCrime) {
  final dateParts = dateOfCrime.split('-');
  final year = int.parse(dateParts[0]);
  final month = int.parse(dateParts[1]);
  final day = int.parse(dateParts[2]);

  final timeParts = timeOfCrime.split(' ');
  final time = timeParts[0]; //  02:30
  final period = timeParts[1]; // PM

  final timeComponents = time.split(':');
  var hour = int.parse(timeComponents[0]);
  final minute = int.parse(timeComponents[1]);

  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return DateTime(year, month, day, hour, minute);
}