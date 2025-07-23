import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/cart/cart_api_model.dart';

part 'create_cart_dto.g.dart';

@JsonSerializable()
class CreateCartDTO {
  final bool success;
  final CartApiModel data;

  CreateCartDTO({
    required this.success,
    required this.data,
  });

  factory CreateCartDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateCartDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCartDTOToJson(this);
}
