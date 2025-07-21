import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/features/home/data/model/order/order_api_model.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';

abstract interface class IOrderRemoteDataSource {
  Future<List<OrderEntity>> getOrdersByUserId(String userId);
  Future<void> createOrder(OrderEntity order);
  Future<void> deleteOrder(String orderId);
}

class OrderRemoteDataSource implements IOrderRemoteDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs tokenSharedPrefs;

  OrderRemoteDataSource({required ApiService apiService, required this.tokenSharedPrefs})
      : _apiService = apiService;

  @override
  Future<List<OrderEntity>> getOrdersByUserId(String userId) async {
    final tokenResult = await tokenSharedPrefs.getToken();
    String? token;
    tokenResult.fold(
      (failure) => print("Failed to get token: ${failure.message}"),
      (savedToken) => token = savedToken,
    );
    final endpoint = ApiEndpoints.getOrderByUserId.replaceFirst(':userId', userId);
    final response = await _apiService.dio.get(
      endpoint,
      options: Options(headers: {'authorization': 'Bearer $token'}),
    );
    final List<OrderApiModel> models = OrderApiModel.fromJsonList(response.data['data']);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> createOrder(OrderEntity order) async {
    final body = OrderApiModel.fromEntity(order).toJson();
    await _apiService.dio.post(ApiEndpoints.createOrder, data: body);
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    final endpoint = ApiEndpoints.deleteOrder.replaceFirst(':id', orderId);
    await _apiService.dio.delete(endpoint);
  }
}
