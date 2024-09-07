import 'package:chat_app/chat/presentation/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsMessages extends StatelessWidget {
  const ChatsMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages yet...'),
          );
        }

        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final loadedMessages = chatSnapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final message = loadedMessages[index].data();
            final nextMessage = index + 1 < loadedMessages.length ? loadedMessages[index + 1].data() : null;

            final currentMessageUserId = message['userId'];
            final nextChatMessageUserId = nextMessage != null ? nextMessage['userId'] : null;

            final nextUserIsSame = nextChatMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(message: message['text'], isMe: authenticatedUser.uid == currentMessageUserId);
            } else {
              return MessageBubble.first(
                username: message['username'],
                message: message['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
                userImage: message['userImage'],
              );
            }
          },
        );
      },
    );
  }
}
