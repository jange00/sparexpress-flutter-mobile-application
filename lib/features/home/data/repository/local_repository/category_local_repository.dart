import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/local_datasource/category_local_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';
import 'package:sparexpress/features/home/domin/repository/category_repository.dart';



class CategoryLocalRepository implements ICategoryRepository {
  final CategoryLocalDataSource _categoryLocalDataSource;

  CategoryLocalRepository({required CategoryLocalDataSource categoryLocalDataSource})
      : _categoryLocalDataSource = categoryLocalDataSource;

  @override
  Future<Either<Failure, void>> createCategory(CategoryEntity category) async {
    try {
      await _categoryLocalDataSource.createCategory(category);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _categoryLocalDataSource.deleteCategory(id);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await _categoryLocalDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
