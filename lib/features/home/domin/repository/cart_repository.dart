import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';

abstract interface class ICartRepository {
  Future<Either<Failure, List<CartEntity>>> getCarts();
  Future<Either<Failure, void>> createCart(CartEntity cart);
  Future<Either<Failure, void>> deleteCart(String id);
}
