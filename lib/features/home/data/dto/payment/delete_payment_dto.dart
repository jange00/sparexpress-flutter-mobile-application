import 'package:json_annotation/json_annotation.dart';

part 'delete_payment_dto.g.dart';

@JsonSerializable()
class DeletePaymentDTO {
  final bool success;
  final String message;

  DeletePaymentDTO({
    required this.success,
    required this.message,
  });

  factory DeletePaymentDTO.fromJson(Map<String, dynamic> json) =>
      _$DeletePaymentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DeletePaymentDTOToJson(this);
}
