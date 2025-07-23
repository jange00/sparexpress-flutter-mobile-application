// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllPaymentDTO _$GetAllPaymentDTOFromJson(Map<String, dynamic> json) =>
    GetAllPaymentDTO(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => PaymentApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllPaymentDTOToJson(GetAllPaymentDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
