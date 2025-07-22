abstract class CheckoutEvent {}

class StartCheckout extends CheckoutEvent {
  final String userId;
  final String productId;
  final int quantity;
  final String shippingAddressId;
  StartCheckout({required this.userId, required this.productId, required this.quantity, required this.shippingAddressId});
}

class ConfirmOrder extends CheckoutEvent {
  final String paymentMethod;
  ConfirmOrder(this.paymentMethod);
} 