import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';
import 'package:sparexpress/features/home/domin/repository/order_repository.dart';

class CreateOrderUsecase implements UseCaseWithParams<void, OrderEntity> {
  final IOrderRepository _repository;

  CreateOrderUsecase({required IOrderRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(OrderEntity order) async {
    try {
      final result = await _repository.createOrder(order);
      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
