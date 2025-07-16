import 'package:json_annotation/json_annotation.dart';

part 'delete_cart_dto.g.dart';

@JsonSerializable()
class DeleteCartDTO {
  final bool success;
  final String message;

  DeleteCartDTO({
    required this.success,
    required this.message,
  });

  factory DeleteCartDTO.fromJson(Map<String, dynamic> json) =>
      _$DeleteCartDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteCartDTOToJson(this);
}
