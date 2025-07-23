import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/repository/cart_repository.dart';

class UpdateCartItemUsecase {
  final ICartRepository repository;
  UpdateCartItemUsecase(this.repository);

  Future<Either<Failure, void>> call(String cartItemId, int quantity) {
    return repository.updateCartItem(cartItemId, quantity);
  }
} 