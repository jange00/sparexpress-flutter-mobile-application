import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/home/domin/use_case/get-all_category_usecase.dart';
import 'package:sparexpress/features/home/domin/repository/category_repository.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockICategoryRepository extends Mock implements ICategoryRepository {}

void main() {
  late GetAllCategoryUsecase useCase;
  late MockICategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockICategoryRepository();
    useCase = GetAllCategoryUsecase(categoryRepository: mockRepository);
  });

  final testCategories = [
    CategoryEntity(categoryId: '1', categoryTitle: 'Electronics'),
    CategoryEntity(categoryId: '2', categoryTitle: 'Clothing'),
    CategoryEntity(categoryId: '3', categoryTitle: 'Books'),
  ];

  group('GetAllCategoryUsecase', () {
    test('should return list of categories when repository call is successful', () async {
      // arrange
      when(() => mockRepository.getCategories()).thenAnswer((_) async => Right(testCategories));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(testCategories));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should return failure when repository call fails', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.getCategories()).thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      when(() => mockRepository.getCategories()).thenThrow(Exception('Unexpected error'));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft(), true);
      expect(result.fold(
        (failure) => failure.message.contains('Unexpected error'),
        (categories) => false,
      ), true);
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should return empty list when repository returns empty list', () async {
      // arrange
      when(() => mockRepository.getCategories()).thenAnswer((_) async => const Right([]));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right([]));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should handle single category response', () async {
      // arrange
      final singleCategory = [CategoryEntity(categoryId: '1', categoryTitle: 'Electronics')];
      when(() => mockRepository.getCategories()).thenAnswer((_) async => Right(singleCategory));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(singleCategory));
      expect(result.fold(
        (failure) => [],
        (categories) => categories,
      ).length, 1);
      verify(() => mockRepository.getCategories()).called(1);
    });
  });
} 