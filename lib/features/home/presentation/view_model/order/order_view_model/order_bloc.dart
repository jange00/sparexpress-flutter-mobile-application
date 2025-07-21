import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/domin/use_case/order/get_all_order_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetAllOrderUsecase getAllOrderUsecase;

  OrderBloc({required this.getAllOrderUsecase}) : super(OrderInitial()) {
    on<GetOrdersByUserIdEvent>((event, emit) async {
      emit(OrderLoading());
      final result = await getAllOrderUsecase();
      result.fold(
        (failure) => emit(OrderError(failure.message)),
        (orders) => emit(OrderLoaded(orders)),
      );
    });
  }
}
