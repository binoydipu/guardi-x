import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/views/chat/chat_list_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final String trustedContactDocId = AuthService.firebase().currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: midnightBlueColor,
        title: const Text(
          "Emergency Messages",
          style: TextStyle(fontWeight: FontWeight.bold, color: whiteColor),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseCloudStorage().getChatsStream(trustedContactDocId),
        builder: (context, trustedContactSnapshot) {
          if (trustedContactSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!trustedContactSnapshot.hasData ||
              !trustedContactSnapshot.data!.exists) {
            return const Center(child: Text("Trusted contact not found!"));
          }

          List<dynamic> chatRefs =
              trustedContactSnapshot.data!.get('chats_reference');

          if (chatRefs.isEmpty) {
            return const Center(child: Text("No chats available!"));
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseCloudStorage().getChatQueryStream(chatRefs),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No chats available!"));
                }

                List<DocumentSnapshot> chatDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    var chatData = chatDocs[index];

                    return StreamBuilder<DocumentSnapshot>(
                      stream: chatData.reference.snapshots(),
                      builder: (context, chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!chatSnapshot.hasData ||
                            !chatSnapshot.data!.exists) {
                          return const SizedBox.shrink();
                        }

                        var currentChatData = chatSnapshot.data!;

                        return FutureBuilder<GestureDetector>(
                          future: chatListView(context, currentChatData),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("Error loading chat"));
                            }
                            if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            }
                            return snapshot.data!;
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
