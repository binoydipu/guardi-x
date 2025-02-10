import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guardix/components/toast.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/dialogs/choose_image_source_dialog.dart';
import 'package:guardix/utilities/helpers/format_timestamp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class MessageView extends StatefulWidget {
  final DocumentReference chatRoomDocRef;
  final String chatRoomId;
  final String currentUserName;
  final String currentUserNumber;
  final String chatPersonName;
  final String chatPersonNumber;
  final String chatLastMessage;
  final Timestamp timestamp;

  const MessageView({
    required this.chatRoomId,
    required this.chatRoomDocRef,
    required this.currentUserName,
    required this.chatPersonName,
    required this.currentUserNumber,
    required this.chatPersonNumber,
    required this.chatLastMessage,
    required this.timestamp,
    super.key,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late TextEditingController _messageController;
  late ScrollController _scrollController; // Scroll controller

  late final ImagePicker _imagePicker;
  // ignore: unused_field
  XFile? _selectedImage;

  Future<void> _pickImage({
    required ImageSource source,
  }) async {
    final XFile? image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _imagePicker = ImagePicker();
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
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: whiteColor,
                ),
                onPressed: () {
                  FirebaseCloudStorage().updateMessageStatus(widget.chatRoomDocRef);

                  FirebaseCloudStorage().updateChat(
                    senderPhone: widget.currentUserNumber,
                    receiverPhone: widget.chatPersonNumber,
                    senderName: widget.currentUserName,
                    receiverName: widget.chatPersonName,
                    message: widget.chatLastMessage,
                    timestamp: widget.timestamp,
                    chatRoomId: widget.chatRoomId,
                    chatRoomReference: widget.chatRoomDocRef,
                    isRead: true,
                  );
                  Navigator.of(context).pop();
                },
              )
            : null,
        title: Text(
          widget.chatPersonName,
          style: const TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              backgroundColor: softBlueColor,
              radius: 16,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
        backgroundColor: midnightBlueColor,
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

                final messages = snapshot.data!.docs;

                // Scroll to bottom when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // FirebaseCloudStorage()
                  //     .updateMessageStatus(widget.chatRoomDocRef);
                  // FirebaseCloudStorage().updateChat(
                  //   senderPhone: widget.currentUserNumber,
                  //   receiverPhone: widget.chatPersonNumber,
                  //   senderName: widget.currentUserName,
                  //   receiverName: widget.chatPersonName,
                  //   message: widget.chatLastMessage,
                  //   timestamp: widget.timestamp,
                  //   chatRoomId: widget.chatRoomId,
                  //   chatRoomReference: widget.chatRoomDocRef,
                  //   isRead: true,
                  // );
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
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blue,
                      size: 28.0,
                    ),
                    onPressed: () {
                      showImageSourceDialog(
                        context: context,
                      ).then(
                        (value) {
                          if (value == 'camera') {
                            _pickImage(source: ImageSource.camera);
                          } else if (value == 'gallery') {
                            _pickImage(source: ImageSource.gallery);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Send Emergency Message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 26.0,
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
                          _scrollToBottom();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build message bubbles
  Widget _buildMessageBubble(
      Map<String, dynamic> data, bool isMe, String message, bool isLink) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width *
              0.33, // At least 1/3 screen width
          maxWidth: MediaQuery.of(context).size.width *
              0.7, // At most 70% screen width
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isMe ? Colors.blue[600] : Colors.grey[200], // Adjusted colors
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 12 : 0),
              topRight: Radius.circular(isMe ? 0 : 12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message text with link detection
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
                    color: isMe ? Colors.white : Colors.black87,
                    decoration:
                        isLink ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: isMe ? Colors.white : Colors.blue,
                  ),
                ),
              ),
              const SizedBox(
                  height: 6), // Spacing between message and timestamp
              // Timestamp and read status
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatTimestamp(data[timestampFieldName], true),
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(
                      width: 4), // Spacing between timestamp and icon
                  if (isMe)
                    Icon(
                      data[isSeenFieldName] ? Icons.done_all : Icons.done,
                      size: 16,
                      color:
                          data[isSeenFieldName] ? Colors.white : Colors.white70,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
