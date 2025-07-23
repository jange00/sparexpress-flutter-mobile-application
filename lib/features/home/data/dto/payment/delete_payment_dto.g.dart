// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletePaymentDTO _$DeletePaymentDTOFromJson(Map<String, dynamic> json) =>
    DeletePaymentDTO(
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeletePaymentDTOToJson(DeletePaymentDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
