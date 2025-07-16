import 'package:equatable/equatable.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';

class ProductDetailState extends Equatable {
  final ProductEntity product;
  final int quantity;
  final bool isLoading;
  final String? error;
  final bool addToCartSuccess;

  const ProductDetailState({
    required this.product,
    this.quantity = 1,
    this.isLoading = false,
    this.error,
    this.addToCartSuccess = false,
  });

  ProductDetailState copyWith({
    ProductEntity? product,
    int? quantity,
    bool? isLoading,
    String? error,
    bool? addToCartSuccess,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      addToCartSuccess: addToCartSuccess ?? false,
    );
  }

  @override
  List<Object?> get props => [product, quantity, isLoading, error, addToCartSuccess];
} 