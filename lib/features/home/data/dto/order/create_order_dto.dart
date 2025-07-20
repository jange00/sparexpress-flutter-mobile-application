import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/order/order_api_model.dart';

part 'create_order_dto.g.dart';

@JsonSerializable()
class CreateOrderDTO {
  final bool success;
  final OrderApiModel data;

  CreateOrderDTO({
    required this.success,
    required this.data,
  });

  factory CreateOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderDTOToJson(this);
}
