import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/cart/cart_api_model.dart';

part 'get_all_cart_dto.g.dart';

@JsonSerializable()
class GetAllCartDTO {
  final bool success;
  final int count;
  final List<CartApiModel> data;

  GetAllCartDTO({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetAllCartDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllCartDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCartDTOToJson(this);
}
