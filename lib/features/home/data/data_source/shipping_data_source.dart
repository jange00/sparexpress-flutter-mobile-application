import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

abstract interface class IShippingAddressDataSource {
  Future<List<ShippingAddressEntity>> getShippingAddresses();
  Future<void> addShippingAddress(ShippingAddressEntity address);
  Future<void> deleteShippingAddress(String id);
}
