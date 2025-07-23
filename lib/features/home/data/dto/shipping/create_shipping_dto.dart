import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/shipping/shipping_address_api_model.dart';

part 'create_shipping_dto.g.dart';

@JsonSerializable()
class CreateShippingAddressDTO {
  final bool success;
  final ShippingAddressApiModel data;

  CreateShippingAddressDTO({
    required this.success,
    required this.data,
  });

  factory CreateShippingAddressDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateShippingAddressDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateShippingAddressDTOToJson(this);
}