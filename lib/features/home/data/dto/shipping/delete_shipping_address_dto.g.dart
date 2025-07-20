// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_shipping_address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteShippingAddressDTO _$DeleteShippingAddressDTOFromJson(
        Map<String, dynamic> json) =>
    DeleteShippingAddressDTO(
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeleteShippingAddressDTOToJson(
        DeleteShippingAddressDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
