import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/order/order_api_model.dart';

part 'get_all_order_dto.g.dart';

@JsonSerializable()
class GetAllOrderDTO {
  final bool success;
  final int count;
  final List<OrderApiModel> data;

  GetAllOrderDTO({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetAllOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllOrderDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllOrderDTOToJson(this);
}