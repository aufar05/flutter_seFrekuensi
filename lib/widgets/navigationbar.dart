import 'package:chattitude/screens/chat.dart';
import 'package:chattitude/screens/chatV2.dart';
import 'package:chattitude/screens/quiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sefrekuensi'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.group,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Tab(
                height: 30,
                child: Container(
                  child: Image.asset(
                    'assets/images/heartbeat.png',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatScreen(),
            FutureBuilder(
              future: checkQuizDataExists(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Terjadi kesalahan.'),
                    );
                  } else {
                    final bool? quizDataExists = snapshot.data;

                    if (quizDataExists != null && quizDataExists) {
                      return ChatScreenV2();
                    } else {
                      return QuizScreen();
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkQuizDataExists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final quizData = userData.data()?['nilai_quiz'];
      return quizData != null;
    }
    return false;
  }
}
