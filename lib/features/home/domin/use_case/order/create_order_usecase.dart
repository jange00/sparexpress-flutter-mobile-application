import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';
import 'package:sparexpress/features/home/domin/repository/order_repository.dart';

class CreateOrderUsecase implements UseCaseWithParams<OrderEntity, OrderEntity> {
  final IOrderRepository _repository;

  CreateOrderUsecase({required IOrderRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, OrderEntity>> call(OrderEntity order) async {
    try {
      final result = await _repository.createOrder(order);
      return result;
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
