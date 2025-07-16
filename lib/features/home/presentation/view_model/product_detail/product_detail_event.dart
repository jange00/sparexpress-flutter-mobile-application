import 'package:equatable/equatable.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();
  @override
  List<Object?> get props => [];
}

class ProductDetailStarted extends ProductDetailEvent {
  final ProductEntity product;
  const ProductDetailStarted(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductDetailQuantityChanged extends ProductDetailEvent {
  final int quantity;
  const ProductDetailQuantityChanged(this.quantity);
  @override
  List<Object?> get props => [quantity];
}

class ProductDetailAddToCart extends ProductDetailEvent {
  final int quantity;
  const ProductDetailAddToCart(this.quantity);
  @override
  List<Object?> get props => [quantity];
} 