import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';

part 'payment_api_model.g.dart';

@JsonSerializable()
class PaymentApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? paymentId;

  final String userId;
  final String orderId;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;

  const PaymentApiModel({
    this.paymentId,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  /// From JSON
  factory PaymentApiModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentApiModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$PaymentApiModelToJson(this);

  /// From Entity
  factory PaymentApiModel.fromEntity(PaymentEntity entity) {
    return PaymentApiModel(
      paymentId: entity.paymentId,
      userId: entity.userId,
      orderId: entity.orderId,
      amount: entity.amount,
      paymentMethod: entity.paymentMethod,
      paymentStatus: entity.paymentStatus,
    );
  }

  /// To Entity
  PaymentEntity toEntity() {
    return PaymentEntity(
      paymentId: paymentId,
      userId: userId,
      orderId: orderId,
      amount: amount,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
    );
  }

  /// From JSON list
  static List<PaymentApiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PaymentApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props =>
      [paymentId, userId, orderId, amount, paymentMethod, paymentStatus];
}
