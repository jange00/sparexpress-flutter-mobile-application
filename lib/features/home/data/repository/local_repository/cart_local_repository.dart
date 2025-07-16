import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/local_datasource/cart_local_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/features/home/domin/repository/cart_repository.dart';

class CartLocalRepository implements ICartRepository {
  final CartLocalDataSource _cartLocalDataSource;

  CartLocalRepository({required CartLocalDataSource cartLocalDataSource})
      : _cartLocalDataSource = cartLocalDataSource;

  @override
  Future<Either<Failure, void>> createCart(CartEntity cart) async {
    try {
      await _cartLocalDataSource.createCart(cart);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCart(String id) async {
    try {
      await _cartLocalDataSource.deleteCart(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartEntity>>> getCarts() async {
    try {
      final carts = await _cartLocalDataSource.getCarts();
      return Right(carts);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
