// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemApiModel _$OrderItemApiModelFromJson(Map<String, dynamic> json) =>
    OrderItemApiModel(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemApiModelToJson(OrderItemApiModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'total': instance.total,
    };

OrderApiModel _$OrderApiModelFromJson(Map<String, dynamic> json) =>
    OrderApiModel(
      orderId: json['_id'] as String?,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      shippingAddressId: json['shippingAddressId'] as String,
      orderStatus: json['orderStatus'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderApiModelToJson(OrderApiModel instance) =>
    <String, dynamic>{
      '_id': instance.orderId,
      'userId': instance.userId,
      'amount': instance.amount,
      'shippingAddressId': instance.shippingAddressId,
      'orderStatus': instance.orderStatus,
      'items': instance.items,
    };
