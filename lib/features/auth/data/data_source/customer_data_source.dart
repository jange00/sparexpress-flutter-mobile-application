import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';

abstract interface class ICustomerDataSource{
    Future<void> registerCustomer(CustomerEntity studentData);

  Future<String> loginCustomer(String username, String password);

  Future<String> uploadProfilePicture(String filePath);

  Future<CustomerEntity> getCurrentUser();

  // Forgot Password Methods
  Future<void> requestPasswordReset(String email);
  Future<void> resetPassword(String token, String newPassword);
}