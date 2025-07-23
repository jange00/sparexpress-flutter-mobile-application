import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/features/home/data/model/payment/payment_api_model.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';

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

    final response = await _apiService.dio.get(
      ApiEndpoints.getPaymentByUserId,
      options: Options(headers: {'authorization': 'Bearer $token'}),
    );

    final List<PaymentApiModel> models = PaymentApiModel.fromJsonList(response.data);
    return models.map((e) => e.toEntity()).toList();
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
