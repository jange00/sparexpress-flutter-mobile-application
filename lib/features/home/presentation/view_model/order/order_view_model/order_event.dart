import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class GetOrdersByUserIdEvent extends OrderEvent {
  final String userId;

  const GetOrdersByUserIdEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
