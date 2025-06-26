import 'package:electronic_store/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,  // Now valid reference
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Navigation delay
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // In your build method:
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, _) {
                return Text(
                  'SONOVISION',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(
                        color: Colors.red.withOpacity(_glowController.value * 0.7),
                        blurRadius: 20 + (20 * _glowController.value),
                      ),
                      Shadow(
                        color: Colors.redAccent.withOpacity(_glowController.value * 0.5),
                        blurRadius: 40 + (20 * _glowController.value),
                      ),
                    ],
                  ),
                );
              },
            )
                .animate()
                .fadeIn(duration: 1200.ms)
                // .scale(duration: 800.ms)
                .then(delay: 500.ms),
            // const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, _) {
                return Text(

                  'Largest electronics store in AP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    // letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.red.withOpacity(_glowController.value * 0.7),
                        blurRadius: 20 + (20 * _glowController.value),
                      ),
                      Shadow(
                        color: Colors.redAccent.withOpacity(_glowController.value * 0.5),
                        blurRadius: 40 + (20 * _glowController.value),
                      ),
                    ],
                  ),
                );
              },
            )
                .animate()
                .fadeIn(duration: 1200.ms)
                // .scale(duration: 800.ms)
                .then(delay: 500.ms),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }
}
