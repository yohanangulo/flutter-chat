import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/core/extensions/extensions.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  void _submitMessage() async {
    final String message = _messageController.text;

    if (message.trim().isEmpty) return;

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'send a message...'),
            ),
          ),
          IconButton(
            color: context.theme.colorScheme.primary,
            icon: const Icon(Icons.send),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}
