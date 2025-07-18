import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:sparexpress/features/splash/presentation/view_model/splash_view_model.dart';

class SplashView extends StatelessWidget {
  
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Call ViewModel to handle navigation logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().init(context);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFFC107), // Yellow background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            BounceInDown(
              duration: const Duration(seconds: 3),
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

            const SizedBox(height: 16),

            // Animation
            SizedBox(
              height: 180,
              width: 180,
              child: Lottie.asset('assets/animation/loading2.json'),
            ),

            const SizedBox(height: 20),
            FadeInUp(
              delay: const Duration(seconds: 1),
              duration: const Duration(seconds: 1),
              child: Column(
                children: const [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Loading your experience...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          'Developed by: Sushant Mahato',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }
}
