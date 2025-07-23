import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';

abstract class CheckoutEvent {}

class StartCheckout extends CheckoutEvent {
  final String userId;
  final List<CartEntity> cartItems;
  final String shippingAddressId;
  StartCheckout({required this.userId, required this.cartItems, required this.shippingAddressId});

  @override
  List<Object?> get props => [userId, cartItems, shippingAddressId];
}

class ConfirmOrder extends CheckoutEvent {
  final String paymentMethod;
  ConfirmOrder(this.paymentMethod);
} 