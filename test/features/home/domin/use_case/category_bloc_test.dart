import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';
import 'package:sparexpress/features/home/domin/repository/category_repository.dart';
import 'package:sparexpress/features/home/domin/use_case/get-all_category_usecase.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockICategoryRepository extends Mock implements ICategoryRepository {}

void main() {
  late GetAllCategoryUsecase useCase;
  late MockICategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockICategoryRepository();
    useCase = GetAllCategoryUsecase(categoryRepository: mockRepository);
  });

  group('CategoryBloc', () {
    final testCategories = [
      const CategoryEntity(categoryId: '1', categoryTitle: 'Electronics'),
    ];

    test('should return categories when successful', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => Right(testCategories));

      final result = await useCase();
      expect(result, Right(testCategories));
    });

    test('should return failure when repository fails', () async {
      final failure = RemoteDatabaseFailure(message: 'error');
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => Left(failure));

      final result = await useCase();
      expect(result, Left(failure));
    });

    test('should handle empty category list', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Right([]));

      final result = await useCase();
      expect(result, const Right([]));
    });
  });
} 