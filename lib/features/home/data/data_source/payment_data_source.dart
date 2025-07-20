import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';

abstract interface class IPaymentDataSource {
  Future<List<PaymentEntity>> getPayments();
  Future<void> createPayment(PaymentEntity payment);
  Future<void> deletePayment(String id);
}
