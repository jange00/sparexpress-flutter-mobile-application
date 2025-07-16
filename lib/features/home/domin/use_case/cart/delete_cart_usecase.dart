import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/repository/cart_repository.dart';

class DeleteCartUsecase implements UseCaseWithParams<void, String> {
  final ICartRepository _cartRepository;

  DeleteCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(String id) async {
    try {
      final result = await _cartRepository.deleteCart(id);
      return result.fold(
        (failure) {
          print("Failure: ${failure.message}");
          return Left(failure);
        },
        (_) {
          print("Success: Cart deleted");
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
