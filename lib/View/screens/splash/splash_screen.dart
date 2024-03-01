import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tiktok_clone/View/screens/home/home_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: LottieBuilder.asset(
          'assets/images/Animation - 1708407497453.json',
          height: 200,
          width: 400,
          fit: BoxFit.cover,
        ),
      ),
      nextScreen: const HomeScreen(),

    );
  }
}