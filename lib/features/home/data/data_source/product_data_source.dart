import 'package:sparexpress/features/home/domin/entity/products_entity.dart';

abstract interface class IProductDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<void> createProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
}
