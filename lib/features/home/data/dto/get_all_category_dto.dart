import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/category/category_api_model.dart';

// dart run build_runner build -d
part 'get_all_category_dto.g.dart';

@JsonSerializable()
class GetAllCategoryDTO {
  final bool success;
  final int count;
  final List<CategoryApiModel> data;

  GetAllCategoryDTO({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetAllCategoryDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllCategoryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCategoryDTOToJson(this);
}
