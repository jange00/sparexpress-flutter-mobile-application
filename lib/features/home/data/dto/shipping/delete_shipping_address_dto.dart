import 'package:json_annotation/json_annotation.dart';

part 'delete_shipping_address_dto.g.dart';

@JsonSerializable()
class DeleteShippingAddressDTO {
  final bool success;
  final String message;

  DeleteShippingAddressDTO({
    required this.success,
    required this.message,
  });

  factory DeleteShippingAddressDTO.fromJson(Map<String, dynamic> json) =>
      _$DeleteShippingAddressDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteShippingAddressDTOToJson(this);
}