import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sparexpress/features/home/presentation/view_model/category_view_model/category_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/category_view_model/category_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/category_view_model/category_state.dart';
import 'package:sparexpress/features/home/domin/use_case/get-all_category_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockGetAllCategoryUsecase extends Mock implements GetAllCategoryUsecase {}

void main() {
  late MockGetAllCategoryUsecase mockGetAllCategoryUsecase;
  late CategoryBloc categoryBloc;

  setUp(() {
    mockGetAllCategoryUsecase = MockGetAllCategoryUsecase();
    categoryBloc = CategoryBloc(getAllCategoryUsecase: mockGetAllCategoryUsecase);
  });

  tearDown(() {
    categoryBloc.close();
  });

  final categories = [
    CategoryEntity(categoryId: '1', categoryTitle: 'Electronics'),
  ];

  blocTest<CategoryBloc, CategoryState>(
    'emits [CategoryLoading, CategoryLoaded] when LoadCategories is added and usecase returns categories',
    build: () {
      when(() => mockGetAllCategoryUsecase()).thenAnswer((_) async => Right(categories));
      return categoryBloc;
    },
    act: (bloc) => bloc.add(const LoadCategories()),
    expect: () => [
      CategoryLoading(),
      CategoryLoaded(categories),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits [CategoryLoading, CategoryError] when LoadCategories is added and usecase returns failure',
    build: () {
      when(() => mockGetAllCategoryUsecase()).thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'error')));
      return categoryBloc;
    },
    act: (bloc) => bloc.add(const LoadCategories()),
    expect: () => [
      CategoryLoading(),
      isA<CategoryError>(),
    ],
  );
} 