import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC107), // Amber background
      body: Center(
        child: BounceInDown(
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
      ),
    );
  }
}
