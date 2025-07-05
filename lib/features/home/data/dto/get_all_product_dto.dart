import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/product_api_model.dart';

// dart run build_runner build -d
part 'get_all_product_dto.g.dart';

@JsonSerializable()
class GetAllProductDTO {
  final bool success;
  final int count;
  final List<ProductApiModel> data;

  GetAllProductDTO({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetAllProductDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllProductDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllProductDTOToJson(this);
}
