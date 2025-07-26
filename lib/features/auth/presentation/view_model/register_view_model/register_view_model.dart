import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/core/common/snackbar/my_snackbar.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_image_upload_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_register_usecase.dart';
import 'package:sparexpress/features/auth/presentation/view/login_view.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final CustomerRegisterUseCase _customerRegisterUseCase;
  final CustomerImageUploadUseCase _customerImageUploadUseCase;

  RegisterViewModel(
    this._customerRegisterUseCase,
    this._customerImageUploadUseCase,
  ) : super(RegisterState.initial()) {
    on<RegisterCustomerEvent>(_onRegisterCustomer);
    on<UploadImageEvent>(_onUploadImage);
  }

  Future<void> _onRegisterCustomer(
    RegisterCustomerEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // First register the user
    final result = await _customerRegisterUseCase(
      RegisterCustomerParams(
        fullName: event.fullName,
        email: event.email,
        phoneNumber: event.phoneNumber,
        password: event.password,
        profileImage: state.imageName,
      ),
    );

    result.fold(
      (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showAppSnackBar(
          event.context,
          message: l.message,
          icon: Icons.error_outline,
          backgroundColor: Colors.red[700],
        );
      },
      (r) async {
        // Registration succeeded
        emit(state.copyWith(isLoading: false, isSuccess: true));
        
        if (state.profileImageFile != null) {
          // Show message that image will be uploaded after login
          showAppSnackBar(
            event.context,
            message: "Registration successful! Please log in to upload your profile picture.",
            icon: Icons.info,
            backgroundColor: Colors.blue[700],
          );
        } else {
          showAppSnackBar(
            event.context,
            message: "Registration Successful",
            icon: Icons.check_circle,
            backgroundColor: Colors.green[700],
          );
        }
        
        // Navigate to login screen after a short delay
        await Future.delayed(const Duration(seconds: 2));
        if (event.context.mounted) {
          Navigator.of(event.context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: LoginView(),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      // Store the image file for later upload after registration
      emit(state.copyWith(
        profileImageFile: event.file,
        isSuccess: true, // Mark as success to show the image in UI
      ));
      print('Image file stored successfully: ${event.file.path}');
    } catch (e) {
      print('Error storing image file: $e');
      emit(state.copyWith(
        profileImageFile: null,
        isSuccess: false,
      ));
    }
  }
}
