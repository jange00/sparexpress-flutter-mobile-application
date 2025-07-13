import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';
import 'package:uuid/uuid.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.categoryId)
class CategoryHiveModel extends Equatable {
  @HiveField(0)
  final String? categoryId;

  @HiveField(1)
  final String categoryTitle;

  CategoryHiveModel({String? categoryId, required this.categoryTitle})
      : categoryId = categoryId ?? const Uuid().v4();

  const CategoryHiveModel.initial() : categoryId = '', categoryTitle = '';

  factory CategoryHiveModel.fromEntity(CategoryEntity entity) =>
      CategoryHiveModel(categoryId: entity.categoryId, categoryTitle: entity.categoryTitle);

  CategoryEntity toEntity() => CategoryEntity(categoryId: categoryId, categoryTitle: categoryTitle);

  static List<CategoryEntity> toEntityList(List<CategoryHiveModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [categoryId, categoryTitle];
}
