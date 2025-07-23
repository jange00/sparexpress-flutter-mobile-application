import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

part 'shipping_api_model.g.dart';

@JsonSerializable()
class ShippingApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String userId;
  final String streetAddress;
  final String postalCode;
  final String city;
  final String district;
  final String province;
  final String country;

  ShippingApiModel({
    this.id,
    required this.userId,
    required this.streetAddress,
    required this.postalCode,
    required this.city,
    required this.district,
    required this.province,
    required this.country,
  });

  factory ShippingApiModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingApiModelToJson(this);

  factory ShippingApiModel.fromEntity(ShippingAddressEntity entity) {
    return ShippingApiModel(
      id: entity.id,
      userId: entity.userId,
      streetAddress: entity.streetAddress,
      postalCode: entity.postalCode,
      city: entity.city,
      district: entity.district,
      province: entity.province,
      country: entity.country,
    );
  }

  ShippingAddressEntity toEntity() {
    return ShippingAddressEntity(
      id: id,
      userId: userId,
      streetAddress: streetAddress,
      postalCode: postalCode,
      city: city,
      district: district,
      province: province,
      country: country,
    );
  }
} 