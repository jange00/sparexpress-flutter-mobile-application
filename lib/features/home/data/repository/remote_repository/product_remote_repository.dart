import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/product_remote_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/repository/products_repository.dart';

class ProductRemoteRepository implements IProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;

  ProductRemoteRepository({
    required ProductRemoteDataSource productRemoteDataSource,
  }) : _productRemoteDataSource = productRemoteDataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await _productRemoteDataSource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> createProduct(ProductEntity product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, void>> createProduct(ProductEntity product) async {
  //   try {
  //     await _productRemoteDataSource.createProduct(product);
  //     return Right(null);
  //   } catch (e) {
  //     return Left(RemoteDatabaseFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> deleteProduct(String productId) async {
  //   try {
  //     await _productRemoteDataSource.deleteProduct(productId);
  //     return Right(null);
  //   } catch (e) {
  //     return Left(RemoteDatabaseFailure(message: e.toString()));
  //   }
  // }
}
