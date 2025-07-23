import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/payment/payment_api_model.dart';

part 'get_all_payment_dto.g.dart';

@JsonSerializable()
class GetAllPaymentDTO {
  final bool success;
  final int count;
  final List<PaymentApiModel> data;

  GetAllPaymentDTO({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetAllPaymentDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllPaymentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllPaymentDTOToJson(this);
}
