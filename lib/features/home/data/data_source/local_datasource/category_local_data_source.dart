import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:sparexpress/features/home/data/data_source/category_data_source.dart';
import 'package:sparexpress/features/home/data/model/category/category_hive_model.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';

class CategoryLocalDataSource implements ICategoryDataSource {
  final HiveService _hiveService;

  CategoryLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> createCategory(CategoryEntity category) async {
    try {
      final categoryHiveModel = CategoryHiveModel.fromEntity(category);
      await _hiveService.addCategory(categoryHiveModel);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _hiveService.deleteCategory(id);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final categoryHiveModels = await _hiveService.getAllCategories();
      return CategoryHiveModel.toEntityList(categoryHiveModels);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
