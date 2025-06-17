
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

class LoginViewModel extends Bloc<LoginEvent, LoginState>{
  final CustomerLoginUseCase _customerLoginUseCase;

  LoginViewModel(this._customerLoginUseCase) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    // on<NavigateToHomeViewEvent>(_onNavigateToHomeView);
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

  //   void _onNavigateToHomeView(
  //   NavigateToHomeViewEvent event,
  //   Emitter<LoginState> emit,
  // ) {
  //   if (event.context.mounted) {
  //     Navigator.pushReplacement(
  //       event.context,
  //       MaterialPageRoute(
  //         builder: (context) => BlocProvider.value(
  //           value: serviceLocator<HomeViewModel>(),
  //           child: const HomeView(),
  //         ),
  //       ),
  //     );
  //   }
  // }

   void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
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
      (token) {
        // Handle success case
        emit(state.copyWith(isLoading: false, isSuccess: true));
        // add(NavigateToHomeViewEvent(context: event.context));
      },
    );
  }
}