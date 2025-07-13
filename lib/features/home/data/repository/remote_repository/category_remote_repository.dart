import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/category_remote_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';
import 'package:sparexpress/features/home/domin/repository/category_repository.dart';


class CategoryRemoteRepository implements ICategoryRepository {
  final CategoryRemoteDataSource _categoryRemoteDataSource;

  CategoryRemoteRepository({
    required CategoryRemoteDataSource categoryRemoteDataSource,
  }) : _categoryRemoteDataSource = categoryRemoteDataSource;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await _categoryRemoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createCategory(CategoryEntity category) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }
}
