import 'package:flutter_bloc/flutter_bloc.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
  }

  Future<void> _onChangePasswordSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordLoading());

    try {
      // Simulate password change logic, e.g. call API
      await Future.delayed(const Duration(seconds: 2));

      // For demo: If old password != 'correct_password', throw error
      if (event.oldPassword != 'correct_password') {
        throw Exception('Old password is incorrect');
      }

      // If success:
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }
}
