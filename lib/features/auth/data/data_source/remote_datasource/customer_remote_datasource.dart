import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/features/auth/data/data_source/customer_data_source.dart';
import 'package:sparexpress/features/auth/data/model/customer_api_model.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';

class CustomerRemoteDatasource implements ICustomerDataSource{
  final ApiService _apiService;
  final TokenSharedPrefs tokenSharedPrefs;

  CustomerRemoteDatasource({required ApiService apiservice,required this.tokenSharedPrefs}) : _apiService = apiservice;

  @override
   Future<void> registerCustomer(CustomerEntity customerData) async {
    try {
      final model = AuthApiModel.fromEntity(customerData);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: model.toJson(),
      );

      print(response);

      if (response.statusCode == 201) {
        return;
      }
    } on DioException catch (e) {
      throw Exception('Failed to register Customer: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> loginCustomer(String email, String password) async {
    print(email);
    print(password);
    try {
      final response = await _apiService.dio.post(ApiEndpoints.login, data: {
        "identifier": email,
        "password": password,
      });
      print(response.data['token']);
     await tokenSharedPrefs.saveToken(response.data['token']);
      final tokenResult = await tokenSharedPrefs.getToken();
tokenResult.fold(
  (failure) => print("Failed to get token: ${failure.message}"),
  (token) => print("Saved token: $token"),
);

      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception("Login failed: ${response.statusCode} ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    print('Uploading image from path: $filePath');
    
    final tokenResult = await tokenSharedPrefs.getToken();
    String? token;
    tokenResult.fold(
      (failure) => token = null,
      (savedToken) => token = savedToken,
    );
    
    print('Token for upload: $token');
    
    try {
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiService.dio.post(
        ApiEndpoints.uploadImage, 
        data: formData,
        options: Options(
          headers: {
            'authorization': token != null ? 'Bearer $token' : '',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('Upload response status: ${response.statusCode}');
      print('Upload response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final imageUrl = response.data['data'] ?? response.data['imageUrl'] ?? response.data['url'];
        if (imageUrl != null) {
          return imageUrl.toString();
        } else {
          throw Exception("Image URL not found in response");
        }
      } else {
        throw Exception("Failed to upload image: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print('DioException in uploadProfilePicture: ${e.response?.data ?? e.message}');
      print('DioException status: ${e.response?.statusCode}');
      throw Exception('Failed to upload picture: ${e.response?.data ?? e.message}');
    } catch (e) {
      print('Unexpected error in uploadProfilePicture: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
  @override
  Future<CustomerEntity> getCurrentUser() async {
    final tokenResult = await tokenSharedPrefs.getToken();
    String? token;
    tokenResult.fold(
      (failure) => token = null,
      (savedToken) => token = savedToken,
    );
    print('Token used for getCurrentUser: $token');
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getMe,
        options: Options(
          headers: {
            'authorization': token != null ? 'Bearer $token' : '',
          },
        ),
      );
      print('getCurrentUser response status: ${response.statusCode}');
      print('getCurrentUser response data: ${response.data}');

      if (response.statusCode == 200) {
        final user = AuthApiModel.fromJson(response.data['data']).toEntity();
        print('Parsed user entity: ' + user.toString());
        return user;
      } else {
        throw Exception("Failed to fetch current user: ${response.statusCode} ${response.statusMessage} ${response.data}");
      }
    } on DioException catch (e) {
      print('DioException in getCurrentUser: ${e.response?.data ?? e.message}');
      throw Exception('Failed to fetch current user: ${e.response?.data ?? e.message}');
    } catch (e) {
      print('Unexpected error in getCurrentUser: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.requestResetPassword,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to request password reset: ${response.statusCode} ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception('Failed to request password reset: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.resetPassword.replaceFirst(':token', token),
        data: {'password': newPassword},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to reset password: ${response.statusCode} ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception('Failed to reset password: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}