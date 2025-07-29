import 'package:sparexpress/core/network/api_service.dart';

class UserRemoteDatasource {
  final ApiService apiService;

  UserRemoteDatasource({required this.apiService});

  Future<void> deleteUser(String userId) async {
    final response = await apiService.dio.delete('/users/$userId');
    if (response.statusCode == 200 && response.data['success'] == true) {
      return;
    } else {
      throw Exception(response.data['message'] ?? 'Failed to delete user');
    }
  }
} 