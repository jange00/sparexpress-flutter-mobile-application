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

  final testProducts = [
    ProductEntity(
      productId: '1',
      name: 'Test Product 1',
      categoryId: 'cat1',
      categoryTitle: 'Category 1',
      subCategoryId: 'sub1',
      subCategoryTitle: 'SubCategory 1',
      brandId: 'brand1',
      brandTitle: 'Brand 1',
      price: 100.0,
      image: ['img1.png'],
      description: 'Test description 1',
      stock: 10,
      shippingCharge: 5.0,
      discount: 10.0,
    ),
    ProductEntity(
      productId: '2',
      name: 'Test Product 2',
      categoryId: 'cat2',
      categoryTitle: 'Category 2',
      subCategoryId: 'sub2',
      subCategoryTitle: 'SubCategory 2',
      brandId: 'brand2',
      brandTitle: 'Brand 2',
      price: 200.0,
      image: ['img2.png'],
      description: 'Test description 2',
      stock: 5,
      shippingCharge: 10.0,
      discount: null,
    ),
  ];

  group('GetAllProductUsecase', () {
    test('should return list of products when repository call is successful', () async {
      // arrange
      when(() => mockRepository.getProducts()).thenAnswer((_) async => Right(testProducts));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(testProducts));
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('should return failure when repository call fails', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.getProducts()).thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      when(() => mockRepository.getProducts()).thenThrow(Exception('Unexpected error'));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft(), true);
      expect(result.fold(
        (failure) => failure.message.contains('Unexpected error'),
        (products) => false,
      ), true);
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('should return empty list when repository returns empty list', () async {
      // arrange
      when(() => mockRepository.getProducts()).thenAnswer((_) async => const Right([]));

      // act
      final result = await useCase();

      // assert
      expect(result.isRight(), true);
      expect(result.fold(
        (failure) => [],
        (products) => products,
      ), isEmpty);
      verify(() => mockRepository.getProducts()).called(1);
    });
  });
}