import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/helpers/format_timestamp.dart';
import 'package:guardix/utilities/helpers/local_storage.dart';
import 'package:guardix/views/chat/message_view.dart';

Future<GestureDetector> chatListView(BuildContext context, var chatData) async {
  String senderName = chatData.get(senderNameFieldName);
  String receiverName = chatData.get(receiverNameFieldName);

  String senderPhone = chatData.get(senderPhoneFieldName);
  String receiverPhone = chatData.get(receiverPhoneFieldName);

  String message = chatData.get(messageFieldName);
  Timestamp timestamp = chatData.get(timestampFieldName);
  String time = formatTimestamp(timestamp, false);

  String currentUserName = await LocalStorage.getUserName() ?? '';
  String currentUserNumber = await LocalStorage.getUserPhone() ?? '';

  String chatPersonName =
      (currentUserName.compareTo(senderName) == 0) ? receiverName : senderName;
  String number = (currentUserNumber.compareTo(senderPhone) == 0)
      ? receiverPhone
      : senderPhone;

  bool isNotRead = !chatData.get(isChatReadFieldName) &&
      (currentUserNumber.compareTo(receiverPhone) == 0);

  return GestureDetector(
    onTap: () async {
      var chatRoomReference = chatData.get('chat_room_reference');

      List<String> ids = [senderPhone, receiverPhone];

      ids.sort();
      String chatRoomId = ids.join('_');

      if (isNotRead) {
        FirebaseCloudStorage().updateMessageStatus(chatRoomReference);

        FirebaseCloudStorage().updateChat(
          senderPhone: senderPhone,
          receiverPhone: receiverPhone,
          senderName: senderName,
          receiverName: receiverName,
          message: message,
          timestamp: timestamp,
          chatRoomId: chatRoomId,
          chatRoomReference: chatRoomReference,
          isRead: true,
        );
      }
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageView(
              chatRoomId: chatRoomId,
              chatRoomDocRef: chatRoomReference,
              currentUserName: currentUserName,
              chatPersonName: chatPersonName,
              currentUserNumber: currentUserNumber,
              chatPersonNumber: number,
              chatLastMessage: message,
              timestamp: timestamp,
              isRead: !isNotRead,
            ),
          ),
        );
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatPersonName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                // Last message
                Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.emergency,
                size: 18,
                color: isNotRead ? brightGreenColor : Colors.transparent,
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: isNotRead ? brightGreenColor : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
