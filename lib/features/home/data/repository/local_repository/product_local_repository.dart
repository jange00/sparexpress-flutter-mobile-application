import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/local_datasource/product_local_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/repository/products_repository.dart';

class ProductLocalRepository implements IProductRepository {
  final ProductLocalDataSource _productLocalDataSource;

  ProductLocalRepository({required ProductLocalDataSource productLocalDataSource})
      : _productLocalDataSource = productLocalDataSource;

  @override
  Future<Either<Failure, void>> createProduct(ProductEntity product) async {
    try {
      await _productLocalDataSource.createProduct(product);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _productLocalDataSource.deleteProduct(id);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await _productLocalDataSource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
