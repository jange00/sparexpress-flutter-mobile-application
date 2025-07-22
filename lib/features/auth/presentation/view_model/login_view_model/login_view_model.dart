
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/core/common/snackbar/my_snackbar.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_login_usecase.dart';
import 'package:sparexpress/features/auth/presentation/view/register_view.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:sparexpress/features/home/presentation/view/home_view.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/app/constant/theme_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_get_current_usecase.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState>{
  final CustomerLoginUseCase _customerLoginUseCase;

  LoginViewModel(this._customerLoginUseCase) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<NavigateToHomeViewEvent>(_onNavigateToHomeView);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

   void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,

        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: serviceLocator<RegisterViewModel>()),
            ],
            child: RegisterView(),
          ),
        ),
      );
    }
  }

    void _onNavigateToHomeView(
    NavigateToHomeViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: serviceLocator<HomeViewModel>(),
            child: const HomeView(),
          ),
        ),
      );
    }
  }

   void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
     print('Login Event Triggered');
      print('Email: ${event.email}');
      print('Password: ${event.password}');
    emit(state.copyWith(isLoading: true));
    final result = await _customerLoginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        // Handle failure case
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) async {
        // Handle success case
        emit(state.copyWith(isLoading: false, isSuccess: true));
        // Fetch user profile and save userId
        final getCurrentUser = serviceLocator<CustomerGetCurrentUseCase>();
        final userResult = await getCurrentUser();
        bool userIdSaved = false;
        await userResult.fold(
          (failure) async {
            showMySnackBar(
              context: event.context,
              message: 'Failed to fetch user profile. Please try again.',
              color: Colors.red,
            );
          },
          (user) async {
            final prefs = serviceLocator<SharedPreferences>();
            if (user.customerId != null && user.customerId!.isNotEmpty) {
              await prefs.setString('userId', user.customerId!);
              print('Saved userId: \'${user.customerId}\' to SharedPreferences');
              userIdSaved = true;
            } else {
              showMySnackBar(
                context: event.context,
                message: 'User ID missing in profile. Please contact support.',
                color: Colors.red,
              );
            }
          },
        );
        if (!userIdSaved) {
          emit(state.copyWith(isLoading: false, isSuccess: false));
          return;
        }
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: serviceLocator<HomeViewModel>(),
              child: const HomeView(),
            ),
          ),
        );
        // Show success toast after navigation
        Future.delayed(const Duration(milliseconds: 300), () {
          ScaffoldMessenger.of(event.context).showSnackBar(
            SnackBar(
              content: const Text('Login successful!'),
              backgroundColor: ThemeConstant.primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        });
      },
    );
  }
}