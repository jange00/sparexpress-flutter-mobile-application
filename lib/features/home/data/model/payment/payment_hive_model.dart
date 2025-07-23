import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';
import 'package:uuid/uuid.dart';

part 'payment_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.paymentId)
class PaymentHiveModel extends Equatable {
  @HiveField(0)
  final String? paymentId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String orderId;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String paymentMethod;

  @HiveField(5)
  final String paymentStatus;

  PaymentHiveModel({
    String? paymentId,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
  }) : paymentId = paymentId ?? const Uuid().v4();

  factory PaymentHiveModel.fromEntity(PaymentEntity entity) => PaymentHiveModel(
        paymentId: entity.paymentId,
        userId: entity.userId,
        orderId: entity.orderId,
        amount: entity.amount,
        paymentMethod: entity.paymentMethod,
        paymentStatus: entity.paymentStatus,
      );

  PaymentEntity toEntity() => PaymentEntity(
        paymentId: paymentId,
        userId: userId,
        orderId: orderId,
        amount: amount,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
      );

  @override
  List<Object?> get props => [paymentId, userId, orderId, amount, paymentMethod, paymentStatus];
}
