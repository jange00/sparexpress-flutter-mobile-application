// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteCartDTO _$DeleteCartDTOFromJson(Map<String, dynamic> json) =>
    DeleteCartDTO(
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeleteCartDTOToJson(DeleteCartDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
