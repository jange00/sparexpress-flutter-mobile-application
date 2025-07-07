import 'package:dio/dio.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/features/home/data/data_source/category_data_source.dart';
import 'package:sparexpress/features/home/data/model/category/category_api_model.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';


class CategoryRemoteDataSource implements ICategoryDataSource {
  final ApiService _apiService;

  CategoryRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllCategory);
      print("API Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        try {
           final List<CategoryEntity> entities = CategoryApiModel.fromJsonList(response.data['data']);
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
  Future<void> createCategory(CategoryEntity category) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCategory(String id) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }
}
