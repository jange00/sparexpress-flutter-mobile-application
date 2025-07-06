import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/features/home/data/dto/get_all_product_dto.dart';
import 'package:sparexpress/features/home/data/model/product_api_model.dart';
import 'package:sparexpress/features/home/data/data_source/product_data_source.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';

class ProductRemoteDataSource implements IProductDataSource {
  final ApiService _apiService;

  ProductRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

@override
Future<List<ProductEntity>> getProducts() async {
  try {
    final response = await _apiService.dio.get(ApiEndpoints.getAllProducts);
    print("API Response: ${response.data}");

    if (response.statusCode == 200 && response.data != null) {
      try {
        final List<ProductEntity> entities = ProductApiModel.fromJsonList(response.data['data']);
;
        // final dto = GetAllProductDTO.fromJson(response.data);
        return entities;
      } catch (e) {
        throw Exception("Parsing error: ${e.toString()}");
      }
    } else {
      throw Exception("Failed: ${response.statusMessage ?? 'Unknown error'}");
    }
  } on DioException catch (e) {
    throw Exception(e.message ?? 'DioException occurred');
  } catch (e) {
    throw Exception("Unhandled exception: ${e.toString()}");
  }
}
  
  @override
  Future<void> createProduct(ProductEntity product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }
  
  @override
  Future<void> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  // Add if needed later
//   @override
//   Future<void> createProduct(ProductEntity product) async {
//     try {
//       final model = ProductApiModel.fromEntity(product);
//       final response = await _apiService.dio.post(
//         ApiEndpoints.createProduct,
//         data: model.toJson(),
//       );

//       if (response.statusCode != 201) {
//         throw Exception(response.statusMessage);
//       }
//     } on DioException catch (e) {
//       throw Exception(e.message ?? 'Dio error');
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   @override
//   Future<void> deleteProduct(String productId) async {
//     try {
//       final response = await _apiService.dio.delete(
//         '${ApiEndpoints.deleteProduct}/$productId',
//       );

//       if (response.statusCode != 204) {
//         throw Exception(response.statusMessage);
//       }
//     } on DioException catch (e) {
//       throw Exception(e.message ?? 'Dio error');
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
}
