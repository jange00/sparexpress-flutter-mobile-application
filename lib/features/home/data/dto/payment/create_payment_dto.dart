import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/payment/payment_api_model.dart';

part 'create_payment_dto.g.dart';

@JsonSerializable()
class CreatePaymentDTO {
  final bool success;
  final PaymentApiModel data;

  CreatePaymentDTO({
    required this.success,
    required this.data,
  });

  factory CreatePaymentDTO.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePaymentDTOToJson(this);
}