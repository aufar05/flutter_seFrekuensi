import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/tunggu.json',
            width: 60,
            height: 60,
          ),
          SizedBox(
            height: 12,
          ),
          Text('Tunggu Sebentar.'),
        ],
      ),
    ));
  }
}
