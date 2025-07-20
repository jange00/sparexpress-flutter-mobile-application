import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';
import 'package:sparexpress/features/home/domin/repository/order_repository.dart';

class GetAllOrderUsecase implements UseCaseWithoutParams<List<OrderEntity>> {
  final IOrderRepository _repository;

  GetAllOrderUsecase({required IOrderRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<OrderEntity>>> call() async {
    try {
      final result = await _repository.getOrdersByUserId();
      return result.fold(
        (failure) => Left(failure),
        (orders) => Right(orders),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
