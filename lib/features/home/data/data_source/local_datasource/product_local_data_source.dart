import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:sparexpress/features/home/data/data_source/product_data_source.dart';
import 'package:sparexpress/features/home/data/model/product_hive_model.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';

class ProductLocalDataSource implements IProductDataSource {
  final HiveService _hiveService;

  ProductLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> createProduct(ProductEntity product) async {
    try {
      final productHiveModel = ProductHiveModel.fromEntity(product);
      await _hiveService.addProduct(productHiveModel);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _hiveService.deleteProduct(id);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final productHiveModels = await _hiveService.getAllProducts();
      return ProductHiveModel.toEntityList(productHiveModels);
    } catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
