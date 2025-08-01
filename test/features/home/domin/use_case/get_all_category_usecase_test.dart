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

  group('GetAllCategoryUsecase', () {
    final testCategories = [
      const CategoryEntity(categoryId: '1', categoryTitle: 'Electronics'),
      const CategoryEntity(categoryId: '2', categoryTitle: 'Clothing'),
    ];

    test('should return list of categories when successful', () async {
      // arrange
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => Right(testCategories));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(testCategories));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should return failure when repository fails', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Failed to fetch categories');
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should return empty list when no categories available', () async {
      // arrange
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Right([]));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right([]));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should handle network errors', () async {
      // arrange
      final failure = RemoteDatabaseFailure(message: 'Network error');
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should handle unexpected exceptions', () async {
      // arrange
      when(() => mockRepository.getCategories())
          .thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(() => useCase(), throwsException);
      verify(() => mockRepository.getCategories()).called(1);
    });
  });
} 