import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

  // Format the DateTime object
  String formattedTime =
      DateFormat('hh:mm a').format(dateTime); // e.g., 02:30 PM

  return formattedTime;
}
