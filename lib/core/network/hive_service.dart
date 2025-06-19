import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/auth/data/model/customer_hive_model.dart';

class HiveService {
  Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationCacheDirectory();
    var path = '${directory.path}sparexpress.db';

    Hive.init(path);

    // Register Adapters
    Hive.registerAdapter(CustomerHiveModelAdapter());

     // Add Dummy Data
    // await addBatchData();
    // await addCourseData();

    // clearAll();
  }

  // Login using email and password
  Future<void> close() async {
    await Hive.close();
  }


  // Auth Queries
   Future<void> register(CustomerHiveModel auth) async {
    var box = await Hive.openBox<CustomerHiveModel>(
      HiveTableConstant.customerBox,
    );
    await box.put(auth.customerId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<CustomerHiveModel>(
      HiveTableConstant.customerBox,
    );
    await box.delete(id);
  }

  Future<List<CustomerHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<CustomerHiveModel>(
      HiveTableConstant.customerBox,
    );
    return box.values.toList();
  }

  // Login using username and password
Future<CustomerHiveModel?> login(String email, String password) async {
  print("Trying to login with email: $email");

  final box = await Hive.openBox<CustomerHiveModel>(
    HiveTableConstant.customerBox,
  );

  try {
    final customer = box.values.firstWhere(
      (element) => element.email == email && element.password == password,
    );

    print("Login success: $customer");
    await box.close();
    return customer;
  } catch (e) {
    print("Login failed: $e");
    await box.close();
    return null; // return null if not found
  }
}

}