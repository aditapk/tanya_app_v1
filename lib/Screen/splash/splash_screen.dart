import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import '../Welcome/welcome_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splashIconSize: 1000,
      splash: const SplashDetail(),
      nextScreen: const WelcomeScreen(),
      splashTransition: SplashTransition.slideTransition,
    );
  }
}

class SplashDetail extends StatelessWidget {
  const SplashDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Logo_screen.jpg',
            width: 300,
            height: 200,
          ),
          const Text(
            'เตือนกินยา',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
