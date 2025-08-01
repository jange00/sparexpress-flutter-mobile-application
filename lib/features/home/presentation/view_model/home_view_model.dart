import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/auth/presentation/view/login_view.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel ({ required this.loginViewModel}) : super(HomeState.initial());

  final LoginViewModel loginViewModel;

  void onTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

   void setUserName(String name) {
    emit(state.copyWith(fullname: name));
  }


  void logout(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async{
      if(context.mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => 
            BlocProvider.value(value: serviceLocator<LoginViewModel>(), child: LoginView()),
            ),
          );
      }
    });
  }
}