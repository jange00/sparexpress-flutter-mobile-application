import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/home/domin/use_case/get_all_product_usecase.dart';
import 'package:sparexpress/features/home/domin/repository/products_repository.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockIProductRepository extends Mock implements IProductRepository {}

void main() {
  late GetAllProductUsecase useCase;
  late MockIProductRepository mockRepository;

  setUp(() {
    mockRepository = MockIProductRepository();
    useCase = GetAllProductUsecase(productRepository: mockRepository);
  });

  group('GetAllProductUsecase', () {
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
      const ProductEntity(
        productId: '2',
        name: 'Another Product',
        categoryId: 'cat2',
        categoryTitle: 'Category2',
        subCategoryId: 'sub2',
        subCategoryTitle: 'SubCategory2',
        brandId: 'brand2',
        brandTitle: 'Brand2',
        price: 200.0,
        image: ['img2.png'],
        description: 'Another Description',
        stock: 5,
        shippingCharge: 10.0,
        discount: null,
      ),
    ];

    test('should return list of products when successful', () async {
      // arrange
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Right(testProducts));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(testProducts));
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('should return failure when repository fails', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Failed to fetch products');
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('should return empty list when no products available', () async {
      // arrange
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => const Right([]));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right([]));
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('should handle network errors', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      when(() => mockRepository.getProducts())
          .thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(() => useCase(), throwsException);
      verify(() => mockRepository.getProducts()).called(1);
    });
  });
}