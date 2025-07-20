import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';

part 'order_api_model.g.dart';

@JsonSerializable()
class OrderItemApiModel extends Equatable {
  final String productId;
  final int quantity;
  final double total;

  const OrderItemApiModel({
    required this.productId,
    required this.quantity,
    required this.total,
  });

  /// From JSON
  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemApiModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$OrderItemApiModelToJson(this);

  /// From Entity
  factory OrderItemApiModel.fromEntity(OrderItemEntity entity) {
    return OrderItemApiModel(
      productId: entity.productId,
      quantity: entity.quantity,
      total: entity.total,
    );
  }

  /// To Entity
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
      quantity: quantity,
      total: total,
    );
  }

  /// From JSON list
  static List<OrderItemApiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => OrderItemApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props => [productId, quantity, total];
}

@JsonSerializable()
class OrderApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? orderId;

  final String userId;
  final double amount;
  final String shippingAddressId;
  final String orderStatus;
  final List<OrderItemApiModel> items;

  const OrderApiModel({
    this.orderId,
    required this.userId,
    required this.amount,
    required this.shippingAddressId,
    required this.orderStatus,
    required this.items,
  });

  /// From JSON
  factory OrderApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderApiModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  /// From Entity
  factory OrderApiModel.fromEntity(OrderEntity entity) {
    return OrderApiModel(
      orderId: entity.orderId,
      userId: entity.userId,
      amount: entity.amount,
      shippingAddressId: entity.shippingAddressId,
      orderStatus: entity.orderStatus,
      items: entity.items.map((e) => OrderItemApiModel.fromEntity(e)).toList(),
    );
  }

  /// To Entity
  OrderEntity toEntity() {
    return OrderEntity(
      orderId: orderId,
      userId: userId,
      amount: amount,
      shippingAddressId: shippingAddressId,
      orderStatus: orderStatus,
      items: items.map((e) => e.toEntity()).toList(),
    );
  }

  /// From JSON list
  static List<OrderApiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => OrderApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props =>
      [orderId, userId, amount, shippingAddressId, orderStatus, items];
}
