import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/features/home/domin/repository/cart_repository.dart';

class CreateCartUsecase implements UseCaseWithParams<void, CartEntity> {
  final ICartRepository _cartRepository;

  CreateCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(CartEntity cart) async {
    try {
      final result = await _cartRepository.createCart(cart);
      return result.fold(
        (failure) {
          print("Failure: ${failure.message}");
          return Left(failure);
        },
        (_) {
          print("Success: Cart created");
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
