import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp, bool isTime) {
  DateTime dateTime = timestamp.toDate();

  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return "Just now";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes}m ago"; // e.g., "5m ago"
  } else if (difference.inHours < 24) {
    return "${difference.inHours}h ago"; // e.g., "3h ago"
  } else if (difference.inDays < 7) {
    return "${difference.inDays}d ago"; // e.g., "2d ago"
  } else {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
