// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShippingAddressHiveModelAdapter
    extends TypeAdapter<ShippingAddressHiveModel> {
  @override
  final int typeId = 4;

  @override
  ShippingAddressHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShippingAddressHiveModel(
      id: fields[0] as String?,
      userId: fields[1] as String,
      streetAddress: fields[2] as String,
      postalCode: fields[3] as String,
      city: fields[4] as String,
      district: fields[5] as String,
      province: fields[6] as String,
      country: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShippingAddressHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.streetAddress)
      ..writeByte(3)
      ..write(obj.postalCode)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.district)
      ..writeByte(6)
      ..write(obj.province)
      ..writeByte(7)
      ..write(obj.country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShippingAddressHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
