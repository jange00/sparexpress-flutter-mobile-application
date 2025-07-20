// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentApiModel _$PaymentApiModelFromJson(Map<String, dynamic> json) =>
    PaymentApiModel(
      paymentId: json['_id'] as String?,
      userId: json['userId'] as String,
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
    );

Map<String, dynamic> _$PaymentApiModelToJson(PaymentApiModel instance) =>
    <String, dynamic>{
      '_id': instance.paymentId,
      'userId': instance.userId,
      'orderId': instance.orderId,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
    };
