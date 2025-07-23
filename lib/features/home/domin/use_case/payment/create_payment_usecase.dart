import 'package:dartz/dartz.dart';
import 'package:sparexpress/app/use_case/usecase.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';
import 'package:sparexpress/features/home/domin/repository/payment_repository.dart';

class CreatePaymentUsecase implements UseCaseWithParams<void, PaymentEntity> {
  final IPaymentRepository _repository;

  CreatePaymentUsecase({required IPaymentRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(PaymentEntity payment) async {
    try {
      final result = await _repository.createPayment(payment);
      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
