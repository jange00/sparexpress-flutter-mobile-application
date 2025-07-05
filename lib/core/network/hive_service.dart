// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sparexpress/app/constant/hive_table_constant.dart';
// import 'package:sparexpress/features/auth/data/model/customer_hive_model.dart';

// class HiveService {
//   Future<void> init() async {
//     // Initialize the database
//     var directory = await getApplicationCacheDirectory();
//     var path = '${directory.path}sparexpress.db';

//     Hive.init(path);

//     // Register Adapters
//     Hive.registerAdapter(CustomerHiveModelAdapter());

//      // Add Dummy Data
//     // await addBatchData();
//     // await addCourseData();

//     // clearAll();
//   }

//   // Login using email and password
//   Future<void> close() async {
//     await Hive.close();
//   }


//   // Auth Queries
//    Future<void> register(CustomerHiveModel auth) async {
//     var box = await Hive.openBox<CustomerHiveModel>(
//       HiveTableConstant.customerBox,
//     );
//     await box.put(auth.customerId, auth);
//   }

//   Future<void> deleteAuth(String id) async {
//     var box = await Hive.openBox<CustomerHiveModel>(
//       HiveTableConstant.customerBox,
//     );
//     await box.delete(id);
//   }

//   Future<List<CustomerHiveModel>> getAllAuth() async {
//     var box = await Hive.openBox<CustomerHiveModel>(
//       HiveTableConstant.customerBox,
//     );
//     return box.values.toList();
//   }

//   // Login using username and password
// Future<CustomerHiveModel?> login(String email, String password) async {
//   print("Trying to login with email: $email");

//   final box = await Hive.openBox<CustomerHiveModel>(
//     HiveTableConstant.customerBox,
//   );

//   try {
//     final customer = box.values.firstWhere(
//       (element) => element.email == email && element.password == password,
//     );

//     print("Login success: $customer");
//     await box.close();
//     return customer;
//   } catch (e) {
//     print("Login failed: $e");
//     await box.close();
//     return null; // return null if not found
//   }
// }

// }

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/auth/data/model/customer_hive_model.dart';
import 'package:sparexpress/features/home/data/model/product_hive_model.dart';

class HiveService {
  Future<void> init() async {
    // Initialize the database path
    var directory = await getApplicationCacheDirectory();
    var path = '${directory.path}sparexpress.db';

    Hive.init(path);

    // Register Adapters
    Hive.registerAdapter(CustomerHiveModelAdapter());
    Hive.registerAdapter(ProductHiveModelAdapter());

    // Add Dummy Product Data (optional)
    // await addDummyProductData();

    // clearAll();
  }

  // Close Hive database
  Future<void> close() async {
    await Hive.close();
  }

  // ======================
  // Auth Queries (unchanged)
  // ======================

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

  // ======================
  // Product Queries (added)
  // ======================

  /// Adds or updates a product in Hive database
  Future<void> addProduct(ProductHiveModel product) async {
    var box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    await box.put(product.productId, product);
  }

  /// Deletes a product by its ID
  Future<void> deleteProduct(String id) async {
    var box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    await box.delete(id);
  }

  /// Returns all products sorted by name
  Future<List<ProductHiveModel>> getAllProducts() async {
    var box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    return box.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Get a single product by ID
  Future<ProductHiveModel?> getProductById(String id) async {
    var box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    return box.get(id);
  }

  /// Add some dummy product data to Hive for testing/demo
  Future<void> addDummyProductData() async {
    final product1 = ProductHiveModel(
      name: 'Brake Pad',
      categoryId: 'cat1',
      subCategoryId: 'sub1',
      brandId: 'brand1',
      price: 500.0,
      image: ['https://example.com/brake_pad.jpg'],
      stock: 15,
      shippingCharge: 50.0,
      discount: 10.0,
    );

    final product2 = ProductHiveModel(
      name: 'Air Filter',
      categoryId: 'cat2',
      subCategoryId: 'sub2',
      brandId: 'brand2',
      price: 300.0,
      image: ['https://example.com/air_filter.jpg'],
      stock: 30,
      shippingCharge: 30.0,
      discount: 0.0,
    );

    await addProduct(product1);
    await addProduct(product2);
  }
}
