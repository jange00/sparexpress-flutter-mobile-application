import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final int quantity;
  final double total;

  const OrderItemEntity({
    required this.productId,
    required this.quantity,
    required this.total,
  });

  @override
  List<Object?> get props => [
        productId,
        quantity,
        total,
      ];
}

class OrderEntity extends Equatable {
  final String? orderId;
  final String userId;
  final double amount;
  final String shippingAddressId;
  final String orderStatus;
  final List<OrderItemEntity> items;

  const OrderEntity({
    this.orderId,
    required this.userId,
    required this.amount,
    required this.shippingAddressId,
    required this.orderStatus,
    required this.items,
  });

  @override
  List<Object?> get props => [
        orderId,
        userId,
        amount,
        shippingAddressId,
        orderStatus,
        items,
      ];

  get totalAmount => null;
}
