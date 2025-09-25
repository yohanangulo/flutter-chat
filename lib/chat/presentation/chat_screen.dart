import 'package:chat_app/chat/presentation/widgets/chats_messages.dart';
import 'package:chat_app/chat/presentation/widgets/new_message.dart';
import 'package:chat_app/core/extensions/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    final token = await fcm.getToken();

    fcm.subscribeToTopic('chat');

    print(token); // we could send this token to our server
  }

  @override
  initState() {
    super.initState();
    _setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
              onPressed: FirebaseAuth.instance.signOut,
            color: context.theme.colorScheme.primary,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
        body: SafeArea(
          top: false,
          child: Column(
        children: [
              Expanded(child: const ChatsMessages()),
          NewMessage(),
        ],
          ),
        ),
      ),
    );
  }
}
