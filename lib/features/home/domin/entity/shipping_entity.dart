import 'package:equatable/equatable.dart';

class ShippingAddressEntity extends Equatable {
  final String? id;
  final String userId;
  final String streetAddress;
  final String postalCode;
  final String city;
  final String district;
  final String province;
  final String country;

  const ShippingAddressEntity({
    this.id,
    required this.userId,
    required this.streetAddress,
    required this.postalCode,
    required this.city,
    required this.district,
    required this.province,
    required this.country,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        streetAddress,
        postalCode,
        city,
        district,
        province,
        country,
      ];
}
