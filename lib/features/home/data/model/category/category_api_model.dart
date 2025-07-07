import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? categoryId;

  final String title;

  const CategoryApiModel({
    this.categoryId,
    required this.title,
  });

  /// From JSON
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  /// Convert to Entity (assuming you have CategoryEntity with same fields)
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      categoryTitle: title,
    );
  }

  /// Convert list of JSONs to list of entities
  static List<CategoryEntity> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CategoryApiModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  List<Object?> get props => [categoryId, title];
}
