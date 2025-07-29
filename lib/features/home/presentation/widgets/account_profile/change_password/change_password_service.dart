import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:dio/dio.dart';

Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  final apiService = serviceLocator<ApiService>();
  final url = ApiEndpoints.baseUrl + ApiEndpoints.changePassword;

  // Get token from shared preferences
  final tokenResult = await serviceLocator<TokenSharedPrefs>().getToken();
  String? token;
  tokenResult.fold(
    (failure) => token = null,
    (savedToken) => token = savedToken,
  );

  final response = await apiService.dio.post(
    url,
    data: {
      'oldPassword': currentPassword, // changed from 'currentPassword'
      'newPassword': newPassword,
    },
    options: Options(
      headers: {
        'authorization': token != null ? 'Bearer $token' : '',
      },
    ),
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(response.data['message'] ?? 'Failed to change password');
  }
} 