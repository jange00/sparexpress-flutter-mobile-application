import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_state.dart';
import 'package:sparexpress/features/home/domin/use_case/get_all_product_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockGetAllProductUsecase extends Mock implements GetAllProductUsecase {}

void main() {
  late MockGetAllProductUsecase mockGetAllProductUsecase;
  late ProductBloc productBloc;

  setUp(() {
    mockGetAllProductUsecase = MockGetAllProductUsecase();
    productBloc = ProductBloc(getAllProducts: mockGetAllProductUsecase);
  });

  tearDown(() {
    productBloc.close();
  });

  final products = [
    ProductEntity(
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
      description: 'desc',
      stock: 10,
      shippingCharge: 5.0,
      discount: 10.0,
    ),
  ];

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductLoaded] when LoadProducts is added and usecase returns products',
    build: () {
      when(() => mockGetAllProductUsecase()).thenAnswer((_) async => Right(products));
      return productBloc;
    },
    act: (bloc) => bloc.add(const LoadProducts()),
    expect: () => [
      ProductLoading(),
      ProductLoaded(products),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductError] when LoadProducts is added and usecase returns failure',
    build: () {
      when(() => mockGetAllProductUsecase()).thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'error')));
      return productBloc;
    },
    act: (bloc) => bloc.add(const LoadProducts()),
    expect: () => [
      ProductLoading(),
      isA<ProductError>(),
    ],
  );
} 