import 'package:sparexpress/core/network/hive_service.dart';
import 'package:sparexpress/features/auth/data/data_source/customer_data_source.dart';
import 'package:sparexpress/features/auth/data/model/customer_hive_model.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';

class CustomerLocalDataSource implements ICustomerDataSource {
  final HiveService _hiveService;

  CustomerLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<String> loginCustomer(String email, String password) async {
    try {
      final customerData = await _hiveService.login(email, password);
      if (customerData != null && customerData.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid email or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<void> registerCustomer(CustomerEntity customer) async {
    try {
      // Convert CustomerEntity to Hive model if necessary
      final customerHiveModel = CustomerHiveModel.fromEntity(customer);
      await _hiveService.register(customerHiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<CustomerEntity> getCurrentUser() async {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
}
