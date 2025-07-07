// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      productId: json['_id'] as String?,
      name: json['name'] as String,
      category:
          IdTitlePair.fromJson(json['categoryId'] as Map<String, dynamic>),
      subCategory:
          IdTitlePair.fromJson(json['subCategoryId'] as Map<String, dynamic>),
      brand: IdTitlePair.fromJson(json['brandId'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String?,
      stock: (json['stock'] as num).toInt(),
      shippingCharge: (json['shippingCharge'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.productId,
      'name': instance.name,
      'categoryId': instance.category,
      'subCategoryId': instance.subCategory,
      'brandId': instance.brand,
      'price': instance.price,
      'image': instance.image,
      'description': instance.description,
      'stock': instance.stock,
      'shippingCharge': instance.shippingCharge,
      'discount': instance.discount,
    };

IdTitlePair _$IdTitlePairFromJson(Map<String, dynamic> json) => IdTitlePair(
      id: json['_id'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$IdTitlePairToJson(IdTitlePair instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
    };
