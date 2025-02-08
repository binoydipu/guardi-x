import 'package:flutter/material.dart';
import 'package:guardix/utilities/format_timestamp.dart';

GestureDetector chatListView(BuildContext context, var chatData) {
  bool isRead = true;
  return GestureDetector(
    onTap: () {},
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
                  chatData.get('senderID'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  chatData.get('message'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          Icon(
            Icons.emergency,
            size: 22,
            color: isRead ? Colors.grey : Colors.red,
          ), // Add your icon here
          const SizedBox(width: 10),
          Text(
            formatTimestamp(chatData.get('timestamp')),
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    ),
  );
}