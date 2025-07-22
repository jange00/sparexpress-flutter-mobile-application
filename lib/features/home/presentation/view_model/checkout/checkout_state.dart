abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}
class CheckoutLoading extends CheckoutState {}
class CheckoutReady extends CheckoutState {
  final String summary;
  CheckoutReady(this.summary);
}
class CheckoutSuccess extends CheckoutState {}
class CheckoutError extends CheckoutState {
  final String message;
  CheckoutError(this.message);
} 