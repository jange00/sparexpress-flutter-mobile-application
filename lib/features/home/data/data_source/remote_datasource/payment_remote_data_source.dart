import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/features/home/data/model/payment/payment_api_model.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IPaymentRemoteDataSource {
  Future<List<PaymentEntity>> getPaymentsByUserId();
  Future<void> createPayment(PaymentEntity payment);
  Future<void> deletePayment(String paymentId);
}

class PaymentRemoteDataSource implements IPaymentRemoteDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs tokenSharedPrefs;

  PaymentRemoteDataSource({required ApiService apiService, required this.tokenSharedPrefs})
      : _apiService = apiService;

  @override
  Future<List<PaymentEntity>> getPaymentsByUserId() async {
    final tokenResult = await tokenSharedPrefs.getToken();
    String? token;
    tokenResult.fold(
      (failure) => print("Failed to get token: ${failure.message}"),
      (savedToken) => token = savedToken,
    );
    if ((token ?? '').isEmpty) {
      print('[PaymentRemoteDataSource] ERROR: Token is missing or empty');
      throw Exception('Authorization token is missing. Please log in again.');
    }

    // Fetch userId from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print('[PaymentRemoteDataSource] Loaded userId: ${userId ?? "<null>"}');
    if (userId == null || userId.isEmpty) {
      print('[PaymentRemoteDataSource] ERROR: User ID not found in SharedPreferences');
      throw Exception('User ID not found in SharedPreferences. Please log in again.');
    }
    final endpoint = ApiEndpoints.getPaymentByUserId.replaceFirst(':userId', userId);
    print('[PaymentRemoteDataSource] Calling endpoint: $endpoint');
    try {
      final response = await _apiService.dio.get(
        endpoint,
        options: Options(headers: {'authorization': 'Bearer $token'}),
      );
      print('[PaymentRemoteDataSource] FULL RAW API RESPONSE: ${response.data.runtimeType} -> ${response.data}');
      print('[PaymentRemoteDataSource] API response: ${response.data}');
      // Handle both {data: [...]} and [...] root responses
      final dynamic raw = response.data;
      List<dynamic> dataList = [];
      if (raw is Map<String, dynamic> && raw['data'] is List) {
        dataList = raw['data'];
      } else if (raw is List) {
        dataList = raw;
      } else {
        print('[PaymentRemoteDataSource] ERROR: Unexpected API response format: ${raw.runtimeType}');
        throw Exception('Unexpected API response format.');
      }
      // Only parse items that are Map<String, dynamic>
      print('[PaymentRemoteDataSource] dataList contents:');
      for (var i = 0; i < dataList.length; i++) {
        print('  [${i}] type: ${dataList[i]?.runtimeType}, value: ${dataList[i]}');
      }
      final List<PaymentApiModel> models = [];
      for (final item in dataList) {
        if (item is Map<String, dynamic>) {
          models.add(PaymentApiModel.fromJson(item));
        } else {
          print('[PaymentRemoteDataSource] WARNING: Skipping non-map item at index ${dataList.indexOf(item)}, type: ${item.runtimeType}');
        }
      }
      return models.map((e) => e.toEntity()).toList();
    } catch (e) {
      print('[PaymentRemoteDataSource] ERROR: ${e.toString()}');
      // If the error indicates no payments found, return empty list instead of throwing
      if (e.toString().contains('No payments found for this user') || 
          e.toString().contains('404') ||
          e.toString().contains('not found')) {
        print('[PaymentRemoteDataSource] No payments found, returning empty list');
        return [];
      }
      throw Exception('Failed to load payments: ${e.toString()}');
    }
  }

  @override
  Future<void> createPayment(PaymentEntity payment) async {
    final tokenResult = await tokenSharedPrefs.getToken();
    String? token;
    tokenResult.fold(
      (failure) => print("Failed to get token: ${failure.message}"),
      (savedToken) => token = savedToken,
    );
    final body = PaymentApiModel.fromEntity(payment).toJson();
    print('Payment POST body: ' + body.toString());
    await _apiService.dio.post(
      ApiEndpoints.createPayment,
      data: body,
      options: Options(headers: {'authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<void> deletePayment(String paymentId) async {
    final endpoint = ApiEndpoints.deletePayment.replaceFirst(':id', paymentId);
    await _apiService.dio.delete(endpoint);
  }
}
