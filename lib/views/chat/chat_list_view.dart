import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  bool isNotRead = !chatData.get(isReadFieldName) &&
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
            senderPhone,
            receiverPhone,
            senderName,
            receiverName,
            message,
            timestamp,
            chatRoomId,
            chatRoomReference,
            true);
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
            ),
          ),
        );
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: Colors.white,
        //   width: 1.0,
        // ),
        boxShadow: const [
          // Add this
          BoxShadow(
            color: Color.fromARGB(255, 233, 236, 241), // Shadow color
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(Icons.person),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatPersonName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),

          Icon(
            Icons.emergency,
            size: 22,
            color: isNotRead ? Colors.red : Colors.grey,
          ), // Add your icon here
          const SizedBox(width: 10),
          Text(
            time,
            style: TextStyle(
                fontSize: 13.0, color: isNotRead ? Colors.red : Colors.grey),
          ),
        ],
      ),
    ),
  );
}
