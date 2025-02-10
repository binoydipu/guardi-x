import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';

class Message {
  final String senderPhone;

  final String receiverPhone;
  final String message;
  final Timestamp timestamp;
  final bool isSeen;

  Message({
    required this.senderPhone,
    required this.receiverPhone,
    required this.message,
    required this.timestamp,
    required this.isSeen,
  });

// convert to a map
  Map<String, dynamic> toMap() {
    return {
      senderPhoneFieldName: senderPhone,
      receiverPhoneFieldName: receiverPhone,
      messageFieldName: message,
      timestampFieldName: timestamp,
      isSeenFieldName: isSeen,
    };
  }
}
