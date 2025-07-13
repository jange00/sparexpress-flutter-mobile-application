import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';
import 'package:sparexpress/features/home/domin/repository/category_repository.dart';


class GetAllCategoryUsecase implements UseCaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository _categoryRepository;

  GetAllCategoryUsecase({required ICategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() async {
    try {
      final result = await _categoryRepository.getCategories();

      return result.fold(
        (failure) {
          print("Failure: ${failure.message}");
          return Left(failure);
        },
        (categories) {
          print("Success: Loaded ${categories.length} categories");
          return Right(categories);
        },
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
