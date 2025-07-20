import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:uuid/uuid.dart';

part 'shipping_address_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.shippingId)
class ShippingAddressHiveModel extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String streetAddress;

  @HiveField(3)
  final String postalCode;

  @HiveField(4)
  final String city;

  @HiveField(5)
  final String district;

  @HiveField(6)
  final String province;

  @HiveField(7)
  final String country;

  ShippingAddressHiveModel({
    String? id,
    required this.userId,
    required this.streetAddress,
    required this.postalCode,
    required this.city,
    required this.district,
    required this.province,
    required this.country,
  }) : id = id ?? const Uuid().v4();

  factory ShippingAddressHiveModel.fromEntity(ShippingAddressEntity entity) =>
      ShippingAddressHiveModel(
        id: entity.id,
        userId: entity.userId,
        streetAddress: entity.streetAddress,
        postalCode: entity.postalCode,
        city: entity.city,
        district: entity.district,
        province: entity.province,
        country: entity.country,
      );

  ShippingAddressEntity toEntity() => ShippingAddressEntity(
        id: id,
        userId: userId,
        streetAddress: streetAddress,
        postalCode: postalCode,
        city: city,
        district: district,
        province: province,
        country: country,
      );

  @override
  List<Object?> get props => [id, userId, streetAddress, postalCode, city, district, province, country];
}
