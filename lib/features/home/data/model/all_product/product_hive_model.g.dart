// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductHiveModelAdapter extends TypeAdapter<ProductHiveModel> {
  @override
  final int typeId = 1;

  @override
  ProductHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductHiveModel(
      productId: fields[0] as String?,
      name: fields[1] as String,
      categoryId: fields[2] as String,
      categoryTitle: fields[3] as String,
      subCategoryId: fields[4] as String,
      subCategoryTitle: fields[5] as String,
      brandId: fields[6] as String,
      brandTitle: fields[7] as String,
      price: fields[8] as double,
      image: (fields[9] as List).cast<String>(),
      description: fields[10] as String?,
      stock: fields[11] as int,
      shippingCharge: fields[12] as double,
      discount: fields[13] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductHiveModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.categoryTitle)
      ..writeByte(4)
      ..write(obj.subCategoryId)
      ..writeByte(5)
      ..write(obj.subCategoryTitle)
      ..writeByte(6)
      ..write(obj.brandId)
      ..writeByte(7)
      ..write(obj.brandTitle)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.image)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.stock)
      ..writeByte(12)
      ..write(obj.shippingCharge)
      ..writeByte(13)
      ..write(obj.discount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
