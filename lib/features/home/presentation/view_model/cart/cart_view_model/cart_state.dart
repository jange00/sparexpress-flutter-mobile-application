
// import 'package:sparexpress/features/home/presentation/widgets/cart/cart_model.dart';

// abstract class CartState {}

// class CartInitial extends CartState {}

// class CartLoading extends CartState {}

// class CartLoaded extends CartState {
//   final List<CartItem> items;
//   final double total;

//   CartLoaded({required this.items, required this.total});
// }

// class CartError extends CartState {
//   final String message;
//   CartError(this.message);
// }


import 'package:equatable/equatable.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartEntity> items;
  final double total;

  CartLoaded({required this.items, required this.total});

  @override
  List<Object?> get props => [items, total];
}

class CartError extends CartState {
  final String message;
  CartError(this.message);

  @override
  List<Object?> get props => [message];
}
