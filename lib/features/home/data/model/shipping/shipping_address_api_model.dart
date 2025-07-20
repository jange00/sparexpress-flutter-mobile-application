// import 'package:equatable/equatable.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

// part 'shipping_address_api_model.g.dart';

// @JsonSerializable()
// class ShippingAddressApiModel extends Equatable {
//   @JsonKey(name: '_id')
//   final String? id;

//   final String userId;
//   final String streetAddress;
//   final String postalCode;
//   final String city;
//   final String district;
//   final String province;
//   final String country;

//   const ShippingAddressApiModel({
//     this.id,
//     required this.userId,
//     required this.streetAddress,
//     required this.postalCode,
//     required this.city,
//     required this.district,
//     required this.province,
//     required this.country,
//   });

//   factory ShippingAddressApiModel.fromJson(Map<String, dynamic> json) =>
//       _$ShippingAddressApiModelFromJson(json);

//   Map<String, dynamic> toJson() => _$ShippingAddressApiModelToJson(this);

//   ShippingAddressEntity toEntity() => ShippingAddressEntity(
//         id: id,
//         userId: userId,
//         streetAddress: streetAddress,
//         postalCode: postalCode,
//         city: city,
//         district: district,
//         province: province,
//         country: country,
//       );

//   @override
//   List<Object?> get props =>
//       [id, userId, streetAddress, postalCode, city, district, province, country];
// }


import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

part 'shipping_address_api_model.g.dart';

@JsonSerializable()
class ShippingAddressApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final String userId;
  final String streetAddress;
  final String postalCode;
  final String city;
  final String district;
  final String province;
  final String country;

  const ShippingAddressApiModel({
    this.id,
    required this.userId,
    required this.streetAddress,
    required this.postalCode,
    required this.city,
    required this.district,
    required this.province,
    required this.country,
  });

  /// From JSON (API -> Model)
  factory ShippingAddressApiModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressApiModelFromJson(json);

  /// To JSON (Model -> API)
  Map<String, dynamic> toJson() => _$ShippingAddressApiModelToJson(this);

  /// From Entity (Domain -> Model)
  factory ShippingAddressApiModel.fromEntity(ShippingAddressEntity entity) {
    return ShippingAddressApiModel(
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

  /// To Entity (Model -> Domain)
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

  /// From JSON list
  static List<ShippingAddressApiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ShippingAddressApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props =>
      [id, userId, streetAddress, postalCode, city, district, province, country];
}
