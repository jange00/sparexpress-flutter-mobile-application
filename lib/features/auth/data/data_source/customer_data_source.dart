import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';

abstract interface class ICustomerDataSource{
    Future<void> registerCustomer(CustomerEntity studentData);

  Future<String> loginCustomer(String username, String password);

  Future<String> uploadProfilePicture(String filePath);

  // Future<StudentEntity> getCurrentUser();
}