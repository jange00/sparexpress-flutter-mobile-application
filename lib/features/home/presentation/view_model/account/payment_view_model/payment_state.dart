import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}
class PaymentLoading extends PaymentState {}
class PaymentSuccess extends PaymentState {}
class PaymentFailure extends PaymentState {
  final String error;
  PaymentFailure(this.error);
}

class PaymentHistoryLoaded extends PaymentState {
  final List<PaymentEntity> payments;
  PaymentHistoryLoaded(this.payments);
} 