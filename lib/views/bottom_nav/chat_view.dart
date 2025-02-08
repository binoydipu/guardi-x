import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/auth/auth_service.dart';
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

          // Get the reference to the chat document inside 'chats'
          List<dynamic> chatRefs =
              trustedContactSnapshot.data!.get('chats_reference');

          if (chatRefs.isEmpty) {
            return const Center(child: Text("No chats available!"));
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: Future.wait(
                List<DocumentReference>.from(
                  trustedContactSnapshot.data!.get('chats_reference'),
                ).map((chatRef) => chatRef.get()),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No chats available!"));
                }

                // Get the list of chat documents
                List<DocumentSnapshot> chatDocs = snapshot.data!;

                // Sort the chats based on timestamp
                chatDocs
                    .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

                return ListView.builder(
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    var chatData = chatDocs[index];
                    return chatListView(context, chatData);
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
