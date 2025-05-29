import 'package:flutter/material.dart';
import 'package:sparexpress/theme/sparexpress_theme.dart';
import 'package:sparexpress/view/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: myApplicationTheme(),
      home: const SplashScreen(),
    );
  }
}