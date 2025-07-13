// import 'package:dartz/dartz.dart';
// import 'package:sparexpress/app/use_case/usecase.dart';
// import 'package:sparexpress/core/error/failure.dart';
// import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
// import 'package:sparexpress/features/home/domin/repository/products_repository.dart';

// class GetAllProductUsecase implements UseCaseWithoutParams<List<ProductEntity>> {
//   final IProductRepository _productRepository;

//   GetAllProductUsecase({required IProductRepository productRepository})
//     : _productRepository = productRepository;

//   @override
//   Future<Either<Failure, List<ProductEntity>>> call() {
//     return _productRepository.getProducts();
//   }
// }

import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/repository/products_repository.dart';

class GetAllProductUsecase implements UseCaseWithoutParams<List<ProductEntity>> {
  final IProductRepository _productRepository;

  GetAllProductUsecase({required IProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call() async {
    try {
      final result = await _productRepository.getProducts();
      
      return result.fold(
        (failure) {
          print("Failure: ${failure.message}");
          return Left(failure);
        },
        (products) {
          print("Success: Loaded ${products.length} products");
          return Right(products);
        },
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
