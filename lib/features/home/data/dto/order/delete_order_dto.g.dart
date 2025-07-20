// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteOrderDTO _$DeleteOrderDTOFromJson(Map<String, dynamic> json) =>
    DeleteOrderDTO(
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeleteOrderDTOToJson(DeleteOrderDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
