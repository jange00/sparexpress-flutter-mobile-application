import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_event.dart';
import 'payment_state.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/domin/use_case/payment/get_all_payment_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<PaymentRequested>((event, emit) async {
      emit(PaymentLoading());
      try {
        // Simulate payment logic
        await Future.delayed(const Duration(seconds: 2));
        emit(PaymentSuccess());
      } catch (e) {
        emit(PaymentFailure(e.toString()));
      }
    });
    on<FetchPaymentHistory>((event, emit) async {
      emit(PaymentLoading());
      final usecase = serviceLocator<GetAllPaymentUsecase>();
      final result = await usecase();
      result.fold(
        (failure) => emit(PaymentFailure(failure.message)),
        (payments) => emit(PaymentHistoryLoaded(payments)),
      );
    });
  }
} 