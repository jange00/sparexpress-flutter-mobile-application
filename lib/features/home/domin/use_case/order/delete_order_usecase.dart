import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/repository/order_repository.dart';

class DeleteOrderUsecase implements UseCaseWithParams<void, String> {
  final IOrderRepository _repository;

  DeleteOrderUsecase({required IOrderRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(String id) async {
    try {
      final result = await _repository.deleteOrder(id);
      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
