import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../authentication/login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: LottieBuilder.asset(
          'assets/images/Animation - 1708406556897.json',
          height: 200,
          width: 400,
          fit: BoxFit.cover,
        ),
      ),
      nextScreen: const LoginScreen(),

    );
  }
}