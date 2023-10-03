import 'package:chattitude/widgets/chat_msg.dart';
import 'package:chattitude/widgets/new_msg.dart';

import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Column(
      children: [Expanded(child: ChatMessages()), NewMessage()],
    ));
  }
}
