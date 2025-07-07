import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:uuid/uuid.dart';

part 'product_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.productTableId)
class ProductHiveModel extends Equatable {
  @HiveField(0)
  final String? productId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final String categoryTitle;

  @HiveField(4)
  final String subCategoryId;

  @HiveField(5)
  final String subCategoryTitle;

  @HiveField(6)
  final String brandId;

  @HiveField(7)
  final String brandTitle;

  @HiveField(8)
  final double price;

  @HiveField(9)
  final List<String> image;

  @HiveField(10)
  final String? description;

  @HiveField(11)
  final int stock;

  @HiveField(12)
  final double shippingCharge;

  @HiveField(13)
  final double? discount;

  ProductHiveModel({
    String? productId,
    required this.name,
    required this.categoryId,
    required this.categoryTitle,
    required this.subCategoryId,
    required this.subCategoryTitle,
    required this.brandId,
    required this.brandTitle,
    required this.price,
    required this.image,
    this.description,
    required this.stock,
    required this.shippingCharge,
    this.discount,
  }) : productId = productId ?? const Uuid().v4();

  const ProductHiveModel.initial()
      : productId = '',
        name = '',
        categoryId = '',
        categoryTitle = '',
        subCategoryId = '',
        subCategoryTitle = '',
        brandId = '',
        brandTitle = '',
        price = 0.0,
        image = const [],
        description = '',
        stock = 0,
        shippingCharge = 0.0,
        discount = 0.0;

  factory ProductHiveModel.fromEntity(ProductEntity entity) => ProductHiveModel(
        productId: entity.productId,
        name: entity.name,
        categoryId: entity.categoryId,
        categoryTitle: entity.categoryTitle,
        subCategoryId: entity.subCategoryId,
        subCategoryTitle: entity.subCategoryTitle,
        brandId: entity.brandId,
        brandTitle: entity.brandTitle,
        price: entity.price,
        image: entity.image,
        description: entity.description,
        stock: entity.stock,
        shippingCharge: entity.shippingCharge,
        discount: entity.discount,
      );

  ProductEntity toEntity() => ProductEntity(
        productId: productId,
        name: name,
        categoryId: categoryId,
        categoryTitle: categoryTitle,
        subCategoryId: subCategoryId,
        subCategoryTitle: subCategoryTitle,
        brandId: brandId,
        brandTitle: brandTitle,
        price: price,
        image: image,
        description: description,
        stock: stock,
        shippingCharge: shippingCharge,
        discount: discount,
      );

  static List<ProductEntity> toEntityList(List<ProductHiveModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        productId,
        name,
        categoryId,
        categoryTitle,
        subCategoryId,
        subCategoryTitle,
        brandId,
        brandTitle,
        price,
        image,
        description,
        stock,
        shippingCharge,
        discount,
      ];
}
