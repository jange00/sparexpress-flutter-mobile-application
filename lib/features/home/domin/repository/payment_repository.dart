import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';

abstract interface class IPaymentRepository {
  // Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId(String userId);
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId();
  Future<Either<Failure, void>> createPayment(PaymentEntity payment);
  Future<Either<Failure, void>> deletePayment(String paymentId);
}
