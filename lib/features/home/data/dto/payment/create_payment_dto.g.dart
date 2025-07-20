// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePaymentDTO _$CreatePaymentDTOFromJson(Map<String, dynamic> json) =>
    CreatePaymentDTO(
      success: json['success'] as bool,
      data: PaymentApiModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatePaymentDTOToJson(CreatePaymentDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
