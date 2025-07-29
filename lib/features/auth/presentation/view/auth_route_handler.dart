import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/auth/presentation/view/login_view.dart';
import 'package:sparexpress/features/auth/presentation/view/reset_password_view.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class AuthRouteHandler {
  static Route<dynamic>? handleRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    
    // Handle reset password route
    if (uri.pathSegments.length >= 2 && 
        uri.pathSegments[0] == 'reset-password') {
      final token = uri.pathSegments[1];
      return MaterialPageRoute(
        builder: (context) => ResetPasswordView(token: token),
        settings: settings,
      );
    }
    
    // Default to login view
    return MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: serviceLocator<LoginViewModel>(),
        child: LoginView(),
      ),
      settings: settings,
    );
  }
} 