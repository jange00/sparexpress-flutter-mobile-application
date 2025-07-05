import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:uuid/uuid.dart';

// dart run build_runner build -d
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
  final String subCategoryId;

  @HiveField(4)
  final String brandId;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final List<String> image;

  @HiveField(7)
  final String? description;

  @HiveField(8)
  final int stock;

  @HiveField(9)
  final double shippingCharge;

  @HiveField(10)
  final double? discount;

  ProductHiveModel({
    String? productId,
    required this.name,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
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
        subCategoryId = '',
        brandId = '',
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
        subCategoryId: entity.subCategoryId,
        brandId: entity.brandId,
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
        subCategoryId: subCategoryId,
        brandId: brandId,
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
        subCategoryId,
        brandId,
        price,
        image,
        description,
        stock,
        shippingCharge,
        discount,
      ];
}
