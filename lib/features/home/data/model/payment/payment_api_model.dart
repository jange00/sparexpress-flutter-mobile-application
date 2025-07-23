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
  final String? createdAt;

  const PaymentApiModel({
    this.paymentId,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.createdAt,
  });

  /// From JSON
  factory PaymentApiModel.fromJson(Map<String, dynamic> json) {
    String parseId(dynamic value) {
      if (value is String) return value;
      if (value is Map<String, dynamic> && value['_id'] is String) return value['_id'];
      return '';
    }
    return PaymentApiModel(
      paymentId: json['_id'] as String?,
      userId: parseId(json['userId']),
      orderId: parseId(json['orderId']),
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] as num? ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() => {
    '_id': paymentId,
    'userId': userId,
    'orderId': orderId,
    'amount': amount,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'createdAt': createdAt,
  };

  /// From Entity
  factory PaymentApiModel.fromEntity(PaymentEntity entity) {
    return PaymentApiModel(
      paymentId: entity.paymentId,
      userId: entity.userId,
      orderId: entity.orderId,
      amount: entity.amount,
      paymentMethod: entity.paymentMethod,
      paymentStatus: entity.paymentStatus,
      createdAt: entity.createdAt,
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
      createdAt: createdAt,
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
