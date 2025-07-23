import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String? productName;
  final String? productImage;
  final double? productPrice;
  final int quantity;
  final double total;

  const OrderItemEntity({
    required this.productId,
    this.productName,
    this.productImage,
    this.productPrice,
    required this.quantity,
    required this.total,
  });

  @override
  List<Object?> get props => [
        productId,
        productName,
        productImage,
        productPrice,
        quantity,
        total,
      ];
}

class OrderEntity extends Equatable {
  final String? orderId;
  final String userId;
  final double? amount;
  final String shippingAddressId;
  final String orderStatus;
  final List<OrderItemEntity> items;

  const OrderEntity({
    this.orderId,
    required this.userId,
    this.amount,
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
}
