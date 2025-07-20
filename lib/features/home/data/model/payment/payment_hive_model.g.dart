// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentHiveModelAdapter extends TypeAdapter<PaymentHiveModel> {
  @override
  final int typeId = 6;

  @override
  PaymentHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentHiveModel(
      paymentId: fields[0] as String?,
      userId: fields[1] as String,
      orderId: fields[2] as String,
      amount: fields[3] as double,
      paymentMethod: fields[4] as String,
      paymentStatus: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.paymentId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.orderId)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.paymentMethod)
      ..writeByte(5)
      ..write(obj.paymentStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
