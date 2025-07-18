// abstract class CartEvent {}

// class LoadCart extends CartEvent {}

// class RemoveCartItem extends CartEvent {
//   final String productId;
//   RemoveCartItem(this.productId);
// }


import 'package:equatable/equatable.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class RemoveCartItem extends CartEvent {
  final String productId;
  RemoveCartItem(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CreateCart extends CartEvent {
  final CartEntity cart;
  CreateCart(this.cart);

  @override
  List<Object?> get props => [cart];
}
