import 'package:chattitude/widgets/new_privatemsg.dart';
import 'package:chattitude/widgets/privatechat_msg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class ChatScreenV2 extends StatefulWidget {
  const ChatScreenV2({Key? key}) : super(key: key);

  @override
  _ChatScreenV2State createState() => _ChatScreenV2State();
}

class _ChatScreenV2State extends State<ChatScreenV2> {
  User? user;
  List<QueryDocumentSnapshot>? availableUsers;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchAvailableUsers();
  }

  Future<void> fetchAvailableUsers() async {
    if (user == null) {
      return; // Jika pengguna belum login, berhenti di sini
    }

    final currentUID = user!.uid; // UID pengguna saat ini
    final currentUserData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUID)
        .get();

    final currentQuizValue = currentUserData.data()?['nilai_quiz'];
    if (currentQuizValue == null) {
      return; // Jika pengguna saat ini tidak memiliki nilai_quiz, berhenti di sini
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: currentUID)
        .where('nilai_quiz',
            isEqualTo: currentQuizValue) // Tambahkan filter ini
        .get();

    setState(() {
      availableUsers = querySnapshot.docs;
    });
  }

  Future<void> startChat(String? otherUserID) async {
    print('startChat function entered');
    if (user == null || otherUserID == null) {
      return; // Handle jika pengguna belum login atau otherUserID null
    }

    final chatRoomId = user!.uid.compareTo(otherUserID) > 0
        ? '${user!.uid}$otherUserID'
        : '$otherUserID${user!.uid}';
    print('Chat room ID: $chatRoomId');

    final existingChatRoom = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .get();

    if (!existingChatRoom.exists) {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .set({
        'users': [user!.uid, otherUserID]..sort(),
      });
    }

    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatRoomPage(chatRoomId: chatRoomId),
        ),
      );
    } catch (e) {
      print('Navigation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (availableUsers == null) {
      return Center(
        child: Lottie.asset(
          'assets/lottie/userLoading.json',
          width: 40,
        ),
      );
    }

    if (availableUsers!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/user_notfound.json',
              width: 40,
            ),
            SizedBox(
              height: 12,
            ),
            Text('Tidak ada pengguna lain yang Sefrekuensi.'),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: availableUsers!.length,
        itemBuilder: (context, index) {
          final userData =
              availableUsers![index].data() as Map<String, dynamic>;
          final otherUserID = userData['uid'] as String?;
          final otherUserImage = userData['image_url'] as String?;

          return ListTile(
            title: Text(userData['username'] ?? 'Username Tidak Tersedia'),
            leading: Container(
                height: 30,
                width: 30,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(otherUserImage!),
                )),
            onTap: () {
              print('User tapped. OtherUserID: $otherUserID');
              startChat(otherUserID);
            },
          );
        },
      ),
    );
  }
}

class ChatRoomPage extends StatelessWidget {
  final String chatRoomId;

  const ChatRoomPage({required this.chatRoomId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room  '),
      ),
      body: Column(
        children: [
          Expanded(
              child: PrivateChatMessages(
            chatRoomId: '$chatRoomId',
          )),
          NewPrivateMessage(chatRoomId: '$chatRoomId')
        ],
      ),
    );
  }
}
