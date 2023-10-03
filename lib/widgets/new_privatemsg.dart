import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewPrivateMessage extends StatefulWidget {
  final String chatRoomId;
  const NewPrivateMessage({required this.chatRoomId, Key? key})
      : super(key: key);

  @override
  State<NewPrivateMessage> createState() => _NewPrivateMessageState();
}

class _NewPrivateMessageState extends State<NewPrivateMessage> {
  final _msgController = TextEditingController();
  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _submitMsg() async {
    final enteredMsg = _msgController.text;

    if (enteredMsg.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _msgController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // Menggunakan widget.chatRoomId untuk mengakses chatRoomId
    FirebaseFirestore.instance
        .collection('private_chats')
        .doc(widget.chatRoomId)
        .collection('messages')
        .add({
      'text': enteredMsg,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _msgController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(labelText: 'Kirim pesan ...'),
          )),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: _submitMsg,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
