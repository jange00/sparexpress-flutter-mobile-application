import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/features/home/data/model/cart/cart_api_model.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';

abstract interface class ICartRemoteDataSource {
  Future<List<CartEntity>> getCartByUserId(String userId);
  Future<void> createCart(CartEntity cart);
  Future<void> deleteCart(String cartId);
  Future<void> clearCartByUserId(String userId); 
}

class CartRemoteDataSource implements ICartRemoteDataSource {
  final ApiService _apiService;

  CartRemoteDataSource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<List<CartEntity>> getCartByUserId(String userId) async {
    try {
      final response = await _apiService.dio.get('${ApiEndpoints.getCartByUser}/$userId');
      print("Cart GET Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final List<CartApiModel> models = CartApiModel.fromJsonList(response.data['data']);
        final cartEntities = models.map((model) => model.toEntity()).toList();
        return cartEntities;
      } else {
        throw Exception("Failed to load cart: ${response.statusMessage ?? 'Unknown error'}");
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.data ?? e.message}');
      throw Exception(e.message ?? 'DioException occurred');
    } catch (e) {
      print('Unhandled error: $e');
      throw Exception("Unhandled exception: ${e.toString()}");
    }
  }

  @override
  Future<void> createCart(CartEntity cart) async {
    try {
      final cartJson = CartApiModel.fromEntity(cart).toJson();

      final response = await _apiService.dio.post(
        ApiEndpoints.createCart,
        data: cartJson,
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create cart: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.data ?? e.message}');
      throw Exception(e.message ?? 'DioException occurred');
    } catch (e) {
      print('Unhandled error: $e');
      throw Exception("Unhandled exception: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteCart(String cartId) async {
    try {
      final endpoint = ApiEndpoints.deleteCart.replaceFirst(':cartItemId', cartId);

      final response = await _apiService.dio.delete(endpoint);

      if (response.statusCode != 200) {
        throw Exception("Failed to delete cart: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.data ?? e.message}');
      throw Exception(e.message ?? 'DioException occurred');
    } catch (e) {
      print('Unhandled error: $e');
      throw Exception("Unhandled exception: ${e.toString()}");
    }
  }
  
  @override
  Future<void> clearCartByUserId(String userId) {
    // TODO: implement clearCartByUserId
    throw UnimplementedError();
  }

  // @override
  // Future<void> clearCartByUserId(String userId) async {
  //   try {
  //     final endpoint = ApiEndpoints.deleteCartById.replaceFirst(':userId', userId);

  //     final response = await _apiService.dio.delete(endpoint);

  //     if (response.statusCode != 200) {
  //       throw Exception("Failed to clear cart: ${response.statusMessage}");
  //     }
  //   } on DioException catch (e) {
  //     print('Dio error: ${e.response?.data ?? e.message}');
  //     throw Exception(e.message ?? 'DioException occurred');
  //   } catch (e) {
  //     print('Unhandled error: $e');
  //     throw Exception("Unhandled exception: ${e.toString()}");
  //   }
  // }
}
