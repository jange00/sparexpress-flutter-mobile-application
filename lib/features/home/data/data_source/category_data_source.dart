import 'package:sparexpress/features/home/domin/entity/category_entity.dart';

abstract interface class ICategoryDataSource {
  Future<List<CategoryEntity>> getCategories();
  Future<void> createCategory(CategoryEntity category);
  Future<void> deleteCategory(String id);
}