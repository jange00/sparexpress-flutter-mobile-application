import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/core/network/api_service.dart';
// import 'package:sparexpress/features/home/data/dto/get_all_product_dto.dart';
import 'package:sparexpress/features/home/data/model/all_product/product_api_model.dart';
import 'package:sparexpress/features/home/data/data_source/product_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';

abstract class IProductRemoteDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity> getProductById(String id);  // Add this line
}

class ProductRemoteDataSource implements IProductRemoteDataSource {
  final ApiService _apiService;

  ProductRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllProducts);
      if (response.statusCode == 200) {
        final List<ProductApiModel> products = (response.data['data'] as List)
            .map((e) => ProductApiModel.fromJson(e))
            .toList();
        return products.map((e) => e.toEntity()).toList();
      }
      throw Exception('Failed to load products');
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    try {
      final response = await _apiService.dio.get('${ApiEndpoints.getAllProducts}/$id');
      if (response.statusCode == 200) {
        final ProductApiModel product = ProductApiModel.fromJson(response.data['data']);
        return product.toEntity();
      }
      throw Exception('Failed to load product');
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
}
