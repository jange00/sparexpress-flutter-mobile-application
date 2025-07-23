import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';

abstract interface class ICartDataSource {
  Future<List<CartEntity>> getCarts();
  Future<void> createCart(CartEntity cart);
  Future<void> deleteCart(String id);
}
