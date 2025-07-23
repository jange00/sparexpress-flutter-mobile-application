// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllOrderDTO _$GetAllOrderDTOFromJson(Map<String, dynamic> json) =>
    GetAllOrderDTO(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => OrderApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllOrderDTOToJson(GetAllOrderDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
