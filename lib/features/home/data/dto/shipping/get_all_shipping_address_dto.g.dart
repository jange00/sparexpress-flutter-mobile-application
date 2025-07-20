// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_shipping_address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllShippingAddressDTO _$GetAllShippingAddressDTOFromJson(
        Map<String, dynamic> json) =>
    GetAllShippingAddressDTO(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              ShippingAddressApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllShippingAddressDTOToJson(
        GetAllShippingAddressDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
