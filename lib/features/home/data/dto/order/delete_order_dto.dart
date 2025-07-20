import 'package:json_annotation/json_annotation.dart';

part 'delete_order_dto.g.dart';

@JsonSerializable()
class DeleteOrderDTO {
  final bool success;
  final String message;

  DeleteOrderDTO({
    required this.success,
    required this.message,
  });

  factory DeleteOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$DeleteOrderDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteOrderDTOToJson(this);
}