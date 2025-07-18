import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:sparexpress/features/auth/presentation/view/login_view.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sparexpress/features/home/presentation/view/home_view.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart'; // <-- Import your home page

class SplashViewModel extends Cubit<void> {
  final TokenSharedPrefs tokenSharedPrefs;
  SplashViewModel({required this.tokenSharedPrefs}) : super(null);

  Future<void> init(BuildContext context) async {
    final tokenResult = await tokenSharedPrefs.getToken();

    String? token;
    tokenResult.fold(
      (failure) => print("Failed to get token: ${failure.message}"),
      (savedToken) {
        token = savedToken;
        print("Saved token: $token");
      },
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    if (token != null && token!.isNotEmpty) {
      // Token exists, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(value: serviceLocator<HomeViewModel>(),child: const HomeView(),), 
        ),
      );
    } else {
      // Token missing, go to LoginView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: serviceLocator<LoginViewModel>(),
            child: LoginView(),
          ),
        ),
      );
    }
  }
}
