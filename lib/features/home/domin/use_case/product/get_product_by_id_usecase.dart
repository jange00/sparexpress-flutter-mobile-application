import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/repository/products_repository.dart';

class GetProductByIdUsecase {
  final IProductRepository _repository;

  GetProductByIdUsecase({required IProductRepository repository})
      : _repository = repository;

  Future<Either<Failure, ProductEntity>> call(String id) async {
    return await _repository.getProductById(id);
  }
} 