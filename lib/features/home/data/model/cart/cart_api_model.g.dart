// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartApiModel _$CartApiModelFromJson(Map<String, dynamic> json) => CartApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      productId:
          ProductInfo.fromJson(json['productId'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartApiModelToJson(CartApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'productId': instance.productId,
      'quantity': instance.quantity,
    };

ProductInfo _$ProductInfoFromJson(Map<String, dynamic> json) => ProductInfo(
      id: json['_id'] as String?,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductInfoToJson(ProductInfo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
    };
