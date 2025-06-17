import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/core/common/snackbar/my_snackbar.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_image_upload_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_register_usecase.dart';
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
        showMySnackBar(
          context: event.context,
          message: l.message,
          color: Colors.red,
        );
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
        );
      },
    );
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _customerImageUploadUseCase(
      UploadImageParams(file: event.file),
    );

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) => emit(
        state.copyWith(isLoading: false, isSuccess: true, imageName: r),
      ),
    );
  }
}
