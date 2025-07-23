import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/local_datasource/payment_local_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';
import 'package:sparexpress/features/home/domin/repository/payment_repository.dart';

class PaymentLocalRepository implements IPaymentRepository {
  final PaymentLocalDataSource _localDataSource;

  PaymentLocalRepository({required PaymentLocalDataSource paymentLocalDataSource})
      : _localDataSource = paymentLocalDataSource;

  @override
  Future<Either<Failure, void>> createPayment(PaymentEntity payment) async {
    try {
      await _localDataSource.createPayment(payment);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePayment(String id) async {
    try {
      await _localDataSource.deletePayment(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId() async {
    try {
      final result = await _localDataSource.getPayments();
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
