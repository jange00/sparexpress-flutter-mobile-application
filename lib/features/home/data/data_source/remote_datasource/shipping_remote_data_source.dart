import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/features/home/data/model/shipping/shipping_address_api_model.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

abstract interface class IShippingAddressRemoteDataSource {
  Future<List<ShippingAddressEntity>> getShippingAddressesByUserId(String userId);
  Future<void> createShippingAddress(ShippingAddressEntity address);
  Future<void> deleteShippingAddress(String addressId);
}

class ShippingAddressRemoteDataSource implements IShippingAddressRemoteDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs tokenSharedPrefs;

  ShippingAddressRemoteDataSource({required ApiService apiService, required this.tokenSharedPrefs})
      : _apiService = apiService;

  @override
  Future<List<ShippingAddressEntity>> getShippingAddressesByUserId(String userId) async {
    final tokenResult = await tokenSharedPrefs.getToken();
    String? token;

    tokenResult.fold(
      (failure) => print("Failed to get token: ${failure.message}"),
      (savedToken) => token = savedToken,
    );

    final endpoint = ApiEndpoints.getShippingAddressesByUserId.replaceFirst(':userId', userId);
    final response = await _apiService.dio.get(
      endpoint,
      options: Options(headers: {'authorization': 'Bearer $token'}),
    );

    // The API response is a Map with a 'data' field containing the list
    final dynamic raw = response.data;
    final List<dynamic> dataList = raw is Map<String, dynamic> && raw['data'] is List ? raw['data'] : <dynamic>[];
    final List<ShippingAddressApiModel> models = ShippingAddressApiModel.fromJsonList(dataList);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> createShippingAddress(ShippingAddressEntity shipping) async {
    final tokenResult = await tokenSharedPrefs.getToken();
    String? token;
    tokenResult.fold(
      (failure) => print("Failed to get token: ${failure.message}"),
      (savedToken) => token = savedToken,
    );
    final body = ShippingAddressApiModel.fromEntity(shipping).toJson();
    await _apiService.dio.post(
      ApiEndpoints.createShippingAddress,
      data: body,
      options: Options(headers: {'authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<void> deleteShippingAddress(String addressId) async {
    final endpoint = ApiEndpoints.deleteShippingAddress.replaceFirst(':id', addressId);
    await _apiService.dio.delete(endpoint);
  }
} 