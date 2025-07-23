import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/payment_remote_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';
import 'package:sparexpress/features/home/domin/repository/payment_repository.dart';

class PaymentRemoteRepository implements IPaymentRepository {
  final PaymentRemoteDataSource _paymentRemoteDataSource;

  PaymentRemoteRepository({
    required PaymentRemoteDataSource paymentRemoteDataSource,
  }) : _paymentRemoteDataSource = paymentRemoteDataSource;

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId() async {
    try {
      final payments = await _paymentRemoteDataSource.getPaymentsByUserId();
      return Right(payments);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createPayment(PaymentEntity payment) async {
    try {
      await _paymentRemoteDataSource.createPayment(payment);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePayment(String id) async {
    try {
      await _paymentRemoteDataSource.deletePayment(id);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
