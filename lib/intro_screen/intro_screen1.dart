import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight =
        MediaQuery.of(context).size.height; // Menggunakan tinggi layar

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight *
                    0.03, // Menggunakan tinggi layar untuk ukuran kotak
              ),
              Lottie.asset(
                'assets/lottie/chatAppLogo.json',
                width: screenWidth *
                    0.8, // Menggunakan lebar layar untuk lebar animasi
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(screenWidth *
                          0.02), // Menggunakan lebar layar untuk jarak padding
                      child: Text(
                        'Selamat datang di SeFrekuensi',
                        style: GoogleFonts.poppins(
                            textStyle: textTheme.headlineSmall,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Text(
                        'Aplikasi Ini membantu anda mencari orang orang yang sefrekuensi',
                        style: GoogleFonts.montserrat(
                            textStyle: textTheme.bodyMedium,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
