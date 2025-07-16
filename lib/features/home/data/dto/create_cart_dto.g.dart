// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCartDTO _$CreateCartDTOFromJson(Map<String, dynamic> json) =>
    CreateCartDTO(
      success: json['success'] as bool,
      data: CartApiModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateCartDTOToJson(CreateCartDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
