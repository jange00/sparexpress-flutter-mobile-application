import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/repository/products_repository.dart';
import 'package:sparexpress/features/home/domin/use_case/get_all_product_usecase.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockIProductRepository extends Mock implements IProductRepository {}

void main() {
  late GetAllProductUsecase useCase;
  late MockIProductRepository mockRepository;

  setUp(() {
    mockRepository = MockIProductRepository();
    useCase = GetAllProductUsecase(productRepository: mockRepository);
  });

  group('ProductBloc', () {
    final testProducts = [
      const ProductEntity(
        productId: '1',
        name: 'Test Product',
        categoryId: 'cat1',
        categoryTitle: 'Category',
        subCategoryId: 'sub1',
        subCategoryTitle: 'SubCategory',
        brandId: 'brand1',
        brandTitle: 'Brand',
        price: 100.0,
        image: ['img1.png'],
        description: 'Test Description',
        stock: 10,
        shippingCharge: 5.0,
        discount: 10.0,
      ),
    ];

    test('should return products when successful', () async {
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Right(testProducts));

      final result = await useCase();
      expect(result, Right(testProducts));
    });

    test('should return failure when repository fails', () async {
      final failure = RemoteDatabaseFailure(message: 'error');
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Left(failure));

      final result = await useCase();
      expect(result, Left(failure));
    });

    test('should handle empty product list', () async {
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => const Right([]));

      final result = await useCase();
      expect(result, const Right([]));
    });
  });
} 