import 'package:electronic_store/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SONOVISION',
              style: TextStyle(
                fontSize: 40,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            )
                .animate()
                .fadeIn(duration: 1200.ms)
                .scale(duration: 800.ms)
                .then(delay: 500.ms),
                // .shake(duration: 600.ms),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
