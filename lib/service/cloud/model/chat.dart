import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';

class Chat {
  final DocumentReference chatRoomReference;
  final String senderPhone;
  final String receiverPhone;
  final String senderName;
  final String receiverName;
  final String lastMessage;
  final Timestamp timestamp;
  final bool isRead;

  Chat({
    required this.chatRoomReference,
    required this.senderPhone,
    required this.receiverPhone,
    required this.senderName,
    required this.receiverName,
    required this.lastMessage,
    required this.timestamp,
    required this.isRead,
  });

// convert to a map
  Map<String, dynamic> toMap() {
    return {
      chatRoomReferenceFieldName: chatRoomReference,
      senderPhoneFieldName: senderPhone,
      receiverPhoneFieldName: receiverPhone,
      senderNameFieldName: senderName,
      receiverNameFieldName: receiverName,
      messageFieldName: lastMessage,
      timestampFieldName: timestamp,
      isReadFieldName: isRead,
    };
  }
}
