import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';

part 'order_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.orderId)
class OrderItemHiveModel extends HiveObject {
  @HiveField(0)
  final String? productId;

  @HiveField(1)
  final int? quantity;

  @HiveField(2)
  final double? total;

  OrderItemHiveModel({
    this.productId,
    this.quantity,
    this.total,
  });

  factory OrderItemHiveModel.fromEntity(OrderItemEntity entity) {
    return OrderItemHiveModel(
      productId: entity.productId,
      quantity: entity.quantity,
      total: entity.total,
    );
  }

  OrderItemEntity toEntity() => OrderItemEntity(
        productId: productId ?? '',
        quantity: quantity ?? 0,
        total: total ?? 0.0,
      );

  @override
  List<Object?> get props => [productId, quantity, total];
}

@HiveType(typeId: HiveTableConstant.orderId)
class OrderHiveModel extends HiveObject {
  @HiveField(0)
  final String? orderId;

  @HiveField(1)
  final String? userId;

  @HiveField(2)
  final double? amount;

  @HiveField(3)
  final String? shippingAddressId;

  @HiveField(4)
  final String? orderStatus;

  @HiveField(5)
  final List<OrderItemHiveModel>? items;

  OrderHiveModel({
    this.orderId,
    this.userId,
    this.amount,
    this.shippingAddressId,
    this.orderStatus,
    this.items,
  });

  factory OrderHiveModel.fromEntity(OrderEntity entity) {
    return OrderHiveModel(
      orderId: entity.orderId,
      userId: entity.userId,
      amount: entity.amount,
      shippingAddressId: entity.shippingAddressId,
      orderStatus: entity.orderStatus,
      items: entity.items.map((e) => OrderItemHiveModel.fromEntity(e)).toList(),
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      orderId: orderId,
      userId: userId ?? '',
      amount: amount ?? 0.0,
      shippingAddressId: shippingAddressId ?? '',
      orderStatus: orderStatus ?? '',
      items: items?.map((e) => e.toEntity()).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [orderId, userId, amount, shippingAddressId, orderStatus, items];
}
