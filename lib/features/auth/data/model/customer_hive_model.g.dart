// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerHiveModelAdapter extends TypeAdapter<CustomerHiveModel> {
  @override
  final int typeId = 0;

  @override
  CustomerHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerHiveModel(
      customerId: fields[0] as String?,
      fullName: fields[1] as String,
      email: fields[2] as String,
      phoneNumber: fields[3] as String,
      profileImage: fields[4] as String?,
      password: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.customerId)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.profileImage)
      ..writeByte(5)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
