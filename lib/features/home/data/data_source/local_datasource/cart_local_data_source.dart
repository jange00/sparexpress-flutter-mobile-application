import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:sparexpress/features/home/data/data_source/cart_data_source.dart';
import 'package:sparexpress/features/home/data/model/cart/cart_hive_model.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';

class CartLocalDataSource implements ICartDataSource {
  final HiveService _hiveService;

  CartLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> createCart(CartEntity cart) async {
    try {
      final cartHiveModel = CartHiveModel.fromEntity(cart);
      await _hiveService.addCart(cartHiveModel);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteCart(String id) async {
    try {
      await _hiveService.deleteCart(id);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<List<CartEntity>> getCarts() async {
    try {
      final cartHiveModels = await _hiveService.getAllCarts();
      return CartHiveModel.toEntityList(cartHiveModels);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  Future<List<CartEntity>> getCartsByUserId(String userId) async {
    try {
      final cartHiveModels = await _hiveService.getAllCarts();
      return CartHiveModel.toEntityList(cartHiveModels)
          .where((cart) => cart.userId == userId)
          .toList();
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
