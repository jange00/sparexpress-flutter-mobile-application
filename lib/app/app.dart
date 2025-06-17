import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/app/theme/app_theme.dart';
import 'package:sparexpress/features/splash/presentation/view/splash_view.dart';
import 'package:sparexpress/features/splash/presentation/view_model/splash_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getApplicationTheme(isDarkMode: false),
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: SplashView(),
      ),
    );
  }
}