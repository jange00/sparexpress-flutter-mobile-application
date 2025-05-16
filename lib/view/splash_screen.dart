import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:sparexpress/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFFFC107), // Amber background
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo / Branding
          BounceInDown(
            duration: const Duration(seconds: 2),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                children: const [
                  TextSpan(text: 'Spare', style: TextStyle(color: Colors.black)),
                  TextSpan(text: 'X', style: TextStyle(color: Colors.red)),
                  TextSpan(text: 'press', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 2),
          Lottie.asset('assets/animation/loading.json')

          // Loading Animation (Fade In)
          // FadeInUp(
          //   delay: const Duration(seconds: 1),
          //   duration: const Duration(seconds: 1),
          //   child: Column(
          //     children: const [
          //       CircularProgressIndicator(
          //         valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          //       ),
          //       SizedBox(height: 12),
          //       Text(
          //         "Loading your experience...",
          //         style: TextStyle(
          //           fontSize: 16,
          //           color: Colors.black87,
          //           fontWeight: FontWeight.w500,
          //           letterSpacing: 0.8,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    ),
  );
}
}

