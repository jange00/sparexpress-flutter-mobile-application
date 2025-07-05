import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';

part 'product_api_model.g.dart';

@JsonSerializable()
class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? productId;
  final String name;

  @JsonKey(name: 'categoryId')
  final IdTitlePair category;

  @JsonKey(name: 'subCategoryId')
  final IdTitlePair subCategory;

  @JsonKey(name: 'brandId')
  final IdTitlePair brand;

  final double price;
  final List<String> image;
  final String? description;
  final int stock;
  final double shippingCharge;
  final double? discount;

  const ProductApiModel({
    this.productId,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.price,
    required this.image,
    this.description,
    required this.stock,
    required this.shippingCharge,
    this.discount,
  });

  /// From JSON
  factory ProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductApiModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);

  /// Convert to Entity
  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      name: name,
      categoryId: category.id,
      categoryTitle: category.title,
      subCategoryId: subCategory.id,
      subCategoryTitle: subCategory.title,
      brandId: brand.id,
      brandTitle: brand.title,
      price: price,
      image: image,
      description: description,
      stock: stock,
      shippingCharge: shippingCharge,
      discount: discount,
    );
  }

  /// List conversion
  static List<ProductEntity> toEntityList(List<ProductApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        productId,
        name,
        category,
        subCategory,
        brand,
        price,
        image,
        description,
        stock,
        shippingCharge,
        discount,
      ];
}

@JsonSerializable()
class IdTitlePair extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String title;

  const IdTitlePair({
    required this.id,
    required this.title,
  });

  factory IdTitlePair.fromJson(Map<String, dynamic> json) =>
      _$IdTitlePairFromJson(json);

  Map<String, dynamic> toJson() => _$IdTitlePairToJson(this);

  @override
  List<Object?> get props => [id, title];
}
