import 'package:chattitude/screens/auth.dart';
import 'package:chattitude/screens/splash.dart';
import 'package:chattitude/widgets/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:chattitude/intro_screen/intro_screen1.dart';
import 'package:chattitude/intro_screen/intro_screen2.dart';
import 'package:chattitude/intro_screen/intro_screen3.dart';

import 'package:flutter/material.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _controller = PageController();
  bool halamanTerakhir = false;

  void _saveIntroStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('intro_status', 'completed');

    restartApp();
  }

  // buat merestart aplikasi.
  void restartApp() async {
    print('restart');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? introStatus = prefs.getString('intro_status');
    Widget _buildHome() {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              halamanTerakhir = (index == 2);
            });
          },
          children: [
            const IntroScreen1(),
            const IntroScreen2(),
            const IntroScreen3(),
          ],
        ),
        Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: const Text(
                    'Lewati',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: SlideEffect(activeDotColor: Colors.white),
                ),
                halamanTerakhir
                    ? GestureDetector(
                        child: const Text(
                          'Selesai',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          _saveIntroStatus();
                        },
                      )
                    : GestureDetector(
                        child: const Text(
                          'Lanjut',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                      ),
              ],
            ))
      ]),
    );
  }
}
