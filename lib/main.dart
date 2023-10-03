import 'package:chattitude/firebase_options.dart';
import 'package:chattitude/screens/auth.dart';
import 'package:chattitude/screens/introduction.dart';
import 'package:chattitude/widgets/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? introStatus = prefs.getString('intro_status');

  Widget _buildHome() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return CustomNavigationBar();
        } else {
          return AuthScreen();
        }
      },
    );
  }

  Widget initialScreen = (introStatus != null && introStatus.isNotEmpty)
      ? _buildHome()
      : IntroductionScreen();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SeFrekuensi',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 80, 133, 193),
        ),
      ),
      home: initialScreen,
    ),
  );
}
