// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderDTO _$CreateOrderDTOFromJson(Map<String, dynamic> json) =>
    CreateOrderDTO(
      success: json['success'] as bool,
      data: OrderApiModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateOrderDTOToJson(CreateOrderDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
