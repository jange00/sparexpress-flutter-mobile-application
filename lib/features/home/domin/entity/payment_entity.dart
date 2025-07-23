import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String? paymentId;
  final String userId;
  final String orderId;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final String? createdAt;

  const PaymentEntity({
    this.paymentId,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        paymentId,
        userId,
        orderId,
        amount,
        paymentMethod,
        paymentStatus,
        createdAt,
      ];
}
