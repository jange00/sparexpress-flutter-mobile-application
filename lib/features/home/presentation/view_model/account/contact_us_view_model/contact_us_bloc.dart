import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/contact_us_view_model/contact_us_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/contact_us_view_model/contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsBloc() : super(ContactUsInitial()) {
    on<ContactMessageSubmitted>(_onMessageSubmitted);
  }

  // The event parameter now includes the phoneNumber
  Future<void> _onMessageSubmitted(
    ContactMessageSubmitted event,
    Emitter<ContactUsState> emit,
  ) async {
    emit(ContactUsLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would pass all the data, including the optional phone number:
      // await repository.sendMessage(
      //   name: event.name,
      //   email: event.email,
      //   message: event.message,
      //   phone: event.phoneNumber,
      // );
      
      if (event.message.toLowerCase().contains('error')) {
        emit(ContactUsFailure('Our server does not like that word. Please try again!'));
      } else {
        emit(ContactUsSuccess('Your message has been sent successfully! We will get back to you soon.'));
      }

    } catch (e) {
      emit(ContactUsFailure('An unexpected error occurred. Please check your connection.'));
    }
  }
}