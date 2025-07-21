// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingApiModel _$ShippingApiModelFromJson(Map<String, dynamic> json) =>
    ShippingApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      streetAddress: json['streetAddress'] as String,
      postalCode: json['postalCode'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      province: json['province'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$ShippingApiModelToJson(ShippingApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'streetAddress': instance.streetAddress,
      'postalCode': instance.postalCode,
      'city': instance.city,
      'district': instance.district,
      'province': instance.province,
      'country': instance.country,
    };
