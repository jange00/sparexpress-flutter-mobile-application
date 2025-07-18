import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/cart_remote_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/features/home/domin/repository/cart_repository.dart';


class CartRemoteRepository implements ICartRepository {
  final CartRemoteDataSource _cartRemoteDataSource;

  CartRemoteRepository({
    required CartRemoteDataSource cartRemoteDataSource,
  }) : _cartRemoteDataSource = cartRemoteDataSource;

  @override
  Future<Either<Failure, List<CartEntity>>> getCartByUserId(String userId) async {
    try {
      final cartItems = await _cartRemoteDataSource.getCartByUserId();
      return Right(cartItems);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createCart(CartEntity cart) async {
    try {
      await _cartRemoteDataSource.createCart(cart);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCart(String cartId) async {
    try {
      await _cartRemoteDataSource.deleteCart(cartId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<CartEntity>>> getCarts() async {
    try {
      final cartItems = await _cartRemoteDataSource.getCartByUserId();
      return Right(cartItems);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
