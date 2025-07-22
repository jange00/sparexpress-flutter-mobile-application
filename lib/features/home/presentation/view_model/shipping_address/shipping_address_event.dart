import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

abstract class ShippingAddressEvent {}

class FetchAddresses extends ShippingAddressEvent {
  final String userId;
  FetchAddresses(this.userId);
}

class AddAddress extends ShippingAddressEvent {
  final ShippingAddressEntity address;
  AddAddress(this.address);
}

class SelectAddress extends ShippingAddressEvent {
  final ShippingAddressEntity address;
  SelectAddress(this.address);
}

class DeleteAddress extends ShippingAddressEvent {
  final String addressId;
  DeleteAddress(this.addressId);
} 