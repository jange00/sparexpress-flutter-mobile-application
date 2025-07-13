import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparexpress/app/constant/hive_table_constant.dart';
import 'package:sparexpress/features/auth/data/model/customer_hive_model.dart';
import 'package:sparexpress/features/home/data/model/all_product/product_hive_model.dart';
import 'package:sparexpress/features/home/data/model/category/category_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationCacheDirectory();
    final path = '${directory.path}/sparexpress.db';

    Hive.init(path);

    // Register Hive Adapters
    Hive.registerAdapter(CustomerHiveModelAdapter());
    Hive.registerAdapter(ProductHiveModelAdapter());
    Hive.registerAdapter(CategoryHiveModelAdapter());
  }

  Future<void> close() async {
    await Hive.close();
  }

  // ======================
  // Auth Queries
  // ======================

  Future<void> register(CustomerHiveModel auth) async {
    final box = await Hive.openBox<CustomerHiveModel>(
      HiveTableConstant.customerBox,
    );
    await box.put(auth.customerId, auth);
  }

  Future<void> deleteAuth(String id) async {
    final box = await Hive.openBox<CustomerHiveModel>(
      HiveTableConstant.customerBox,
    );
    await box.delete(id);
  }

  Future<List<CustomerHiveModel>> getAllAuth() async {
    final box = await Hive.openBox<CustomerHiveModel>(
      HiveTableConstant.customerBox,
    );
    return box.values.toList();
  }

  Future<CustomerHiveModel?> login(String email, String password) async {
    final box = await Hive.openBox<CustomerHiveModel>(
      HiveTableConstant.customerBox,
    );

    try {
      final customer = box.values.firstWhere(
        (element) => element.email == email && element.password == password,
      );
      await box.close();
      return customer;
    } catch (e) {
      await box.close();
      return null;
    }
  }

  // ======================
  // Product Queries
  // ======================

  Future<void> addProduct(ProductHiveModel product) async {
    final box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    await box.put(product.productId, product);
  }

  Future<void> deleteProduct(String id) async {
    final box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    await box.delete(id);
  }

  Future<List<ProductHiveModel>> getAllProducts() async {
    final box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    final products = box.values.toList();
    products.sort((a, b) => a.name.compareTo(b.name));
    return products;
  }

  Future<ProductHiveModel?> getProductById(String id) async {
    final box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    return box.get(id);
  }

  /// Dummy Data (with new titles)
  // Future<void> addDummyProductData() async {
  //   final product1 = ProductHiveModel(
  //     name: 'Brake Pad',
  //     categoryId: 'cat1',
  //     categoryTitle: 'Car Parts',
  //     subCategoryId: 'sub1',
  //     subCategoryTitle: 'Brakes',
  //     brandId: 'brand1',
  //     brandTitle: 'Bosch',
  //     price: 500.0,
  //     image: ['https://example.com/brake_pad.jpg'],
  //     stock: 15,
  //     shippingCharge: 50.0,
  //     discount: 10.0,
  //   );

  //   final product2 = ProductHiveModel(
  //     name: 'Air Filter',
  //     categoryId: 'cat2',
  //     categoryTitle: 'Car Parts',
  //     subCategoryId: 'sub2',
  //     subCategoryTitle: 'Filter',
  //     brandId: 'brand2',
  //     brandTitle: 'Philips',
  //     price: 300.0,
  //     image: ['https://example.com/air_filter.jpg'],
  //     stock: 30,
  //     shippingCharge: 30.0,
  //     discount: 0.0,
  //   );

  //   await addProduct(product1);
  //   await addProduct(product2);
  // }

  // ======================
  // Category Queries
  // ======================

  Future<void> addCategory(CategoryHiveModel category) async {
    final box = await Hive.openBox<CategoryHiveModel>(
      HiveTableConstant.categoryBox,
    );
    await box.put(category.categoryId, category);
  }

  Future<void> deleteCategory(String id) async {
    final box = await Hive.openBox<CategoryHiveModel>(
      HiveTableConstant.categoryBox,
    );
    await box.delete(id);
  }

  Future<List<CategoryHiveModel>> getAllCategories() async {
    final box = await Hive.openBox<CategoryHiveModel>(
      HiveTableConstant.categoryBox,
    );
    final categories = box.values.toList();
    categories.sort((a, b) => a.categoryTitle.compareTo(b.categoryTitle));
    return categories;
  }

  Future<CategoryHiveModel?> getCategoryById(String id) async {
    final box = await Hive.openBox<CategoryHiveModel>(
      HiveTableConstant.categoryBox,
    );
    return box.get(id);
  }

}
