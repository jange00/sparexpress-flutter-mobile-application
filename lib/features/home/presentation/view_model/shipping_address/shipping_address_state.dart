import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

abstract class ShippingAddressState {}

class ShippingAddressInitial extends ShippingAddressState {}
class ShippingAddressLoading extends ShippingAddressState {}
class ShippingAddressLoaded extends ShippingAddressState {
  final List<ShippingAddressEntity> addresses;
  ShippingAddressLoaded(this.addresses);
}
class ShippingAddressError extends ShippingAddressState {
  final String message;
  ShippingAddressError(this.message);
}
class ShippingAddressSelected extends ShippingAddressState {
  final ShippingAddressEntity address;
  ShippingAddressSelected(this.address);
} 