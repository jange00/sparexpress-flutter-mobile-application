import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? productId;
  final String name;
  final String categoryId;
  final String subCategoryId;
  final String brandId;
  final double price;
  final List<String> image;
  final String? description;
  final int stock;
  final double shippingCharge;
  final double? discount;

  const ProductEntity({
    this.productId,
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
  });

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
        // shippingCharge,
        discount,
      ];
}
