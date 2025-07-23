import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';
import 'package:sparexpress/features/home/domin/repository/payment_repository.dart';

class GetAllPaymentUsecase implements UseCaseWithoutParams<List<PaymentEntity>> {
  final IPaymentRepository _repository;

  GetAllPaymentUsecase({required IPaymentRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<PaymentEntity>>> call() async {
    try {
      final result = await _repository.getPaymentsByUserId();
      return result.fold(
        (failure) => Left(failure),
        (payments) => Right(payments),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
