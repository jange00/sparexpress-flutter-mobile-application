import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/repository/remote_repository/cart_remote_repostiory.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/features/home/domin/repository/cart_repository.dart';

class GetAllCartUsecase implements UseCaseWithoutParams<List<CartEntity>> {
  final CartRemoteRepository _cartRepository;

  GetAllCartUsecase({required CartRemoteRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, List<CartEntity>>> call() async {
    try {
      final result = await _cartRepository.getCarts();

      return result.fold(
        (failure) {
          print("Failure: ${failure.message}");
          return Left(failure);
        },
        (carts) {
          print("Success: Loaded ${carts.length} carts");
          return Right(carts);
        },
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
