import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guardix/components/toast.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/helpers/format_timestamp.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class MessageView extends StatefulWidget {
  final DocumentReference chatRoomDocRef;
  final String chatRoomId;
  final String currentUserName;
  final String currentUserNumber;
  final String chatPersonName;
  final String chatPersonNumber;

  const MessageView({
    required this.chatRoomId,
    required this.chatRoomDocRef,
    required this.currentUserName,
    required this.chatPersonName,
    required this.currentUserNumber,
    required this.chatPersonNumber,
    super.key,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late TextEditingController _messageController;
  late ScrollController _scrollController; // Scroll controller

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Function to open a link in browser or maps
  void _openLink(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showToast('Can\'t launch URL');
    }
  }

  // Function to scroll to the bottom
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: midnightBlueColor,
        title: Text(
          widget.chatPersonName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 16,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.chatRoomDocRef
                  .collection(messageCollectionName)
                  .orderBy(timestampFieldName, descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }

                var messages = snapshot.data!.docs;

                // Scroll to bottom when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController, // Attach ScrollController
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var data = messages[index].data() as Map<String, dynamic>;
                    final String message = data[messageFieldName];
                    bool isLink = message.startsWith('http://') ||
                        message.startsWith('https://');
                    bool isMe =
                        widget.currentUserNumber == data[senderPhoneFieldName];

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                        child: _buildMessageBubble(data, isMe, message, isLink),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 12.0, 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Send Emergency Message...",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      FirebaseCloudStorage().sendMessage(
                        widget.currentUserNumber,
                        widget.chatPersonNumber,
                        widget.currentUserName,
                        widget.chatPersonName,
                        _messageController.text,
                        widget.chatRoomId,
                        widget.chatRoomDocRef,
                      );

                      _messageController.clear();
                      _scrollToBottom(); // Scroll after sending message
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build message bubbles
  Widget _buildMessageBubble(
      Map<String, dynamic> data, bool isMe, String message, bool isLink) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width *
            0.33, // At least 1/3 screen width
        maxWidth:
            MediaQuery.of(context).size.width * 0.7, // At most 70% screen width
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.lightGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detect and show links as clickable
            GestureDetector(
              onTap: () {
                if (isLink) {
                  try {
                    _openLink(message);
                  } catch (e) {
                    showToast('Can\'t launch URL');
                  }
                }
              },
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  decoration:
                      isLink ? TextDecoration.underline : TextDecoration.none,
                  decorationColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatTimestamp(data[timestampFieldName], true),
                  style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.black87,
                      fontSize: 10),
                ),
                const SizedBox(width: 4),
                Icon(
                  data[isSeenFieldName] ? Icons.done_all : Icons.done,
                  size: 20,
                  color: data[isSeenFieldName]
                      ? (isMe ? safetyOrangeColorLite : Colors.lightGreen)
                      : Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
