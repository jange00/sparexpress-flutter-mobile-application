// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_shipping_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateShippingAddressDTO _$CreateShippingAddressDTOFromJson(
        Map<String, dynamic> json) =>
    CreateShippingAddressDTO(
      success: json['success'] as bool,
      data: ShippingAddressApiModel.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateShippingAddressDTOToJson(
        CreateShippingAddressDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
