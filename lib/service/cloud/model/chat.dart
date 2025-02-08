import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';

class Chat {
  final DocumentReference chatRoomReference;
  final String senderPhone;

  final String lastMessage;
  final Timestamp timestamp;

  Chat({
    required this.chatRoomReference,
    required this.senderPhone,
    required this.lastMessage,
    required this.timestamp,
  });

// convert to a map
  Map<String, dynamic> toMap() {
    return {
      chatRoomReferenceFieldName: chatRoomReference,
      senderPhoneFieldName: senderPhone,
      messageFieldName: lastMessage,
      timestampFieldName: timestamp,
    };
  }
}
