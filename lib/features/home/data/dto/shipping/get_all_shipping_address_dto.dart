import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/data/model/shipping/shipping_address_api_model.dart';

part 'get_all_shipping_address_dto.g.dart';

@JsonSerializable()
class GetAllShippingAddressDTO {
  final bool success;
  final int count;
  final List<ShippingAddressApiModel> data;

  GetAllShippingAddressDTO({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetAllShippingAddressDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllShippingAddressDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllShippingAddressDTOToJson(this);
}
