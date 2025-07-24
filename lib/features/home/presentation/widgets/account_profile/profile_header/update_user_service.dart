import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/core/network/api_service.dart';

Future<Map<String, dynamic>> updateUserProfile({
  required String userId,
  required String name,
  required String email,
  required String phone,
  File? imageFile,
}) async {
  final apiService = serviceLocator<ApiService>();
  final endpoint = ApiEndpoints.updateUsers.replaceFirst(':id', userId);
  final url = ApiEndpoints.baseUrl + endpoint;

  final formData = FormData.fromMap({
    'fullname': name,
    'email': email,
    'phoneNumber': phone,
    if (imageFile != null)
      'profilePicture': await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
  });

  final response = await apiService.dio.put(
    url,
    data: formData,
    options: Options(contentType: 'multipart/form-data'),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return response.data is Map<String, dynamic> ? response.data : {'success': true};
  } else {
    throw Exception('Failed to update profile: ${response.statusMessage ?? response.statusCode}');
  }
} 