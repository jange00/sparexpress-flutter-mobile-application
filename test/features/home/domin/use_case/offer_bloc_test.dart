import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sparexpress/features/home/presentation/view_model/dicounted_products_view_model/offer_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dicounted_products_view_model/offer_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/dicounted_products_view_model/offer_state.dart';
import 'package:sparexpress/features/home/domin/use_case/get_all_product_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/core/error/failure.dart';

class MockGetAllProductUsecase extends Mock implements GetAllProductUsecase {}

void main() {
  late MockGetAllProductUsecase mockGetAllProductUsecase;
  late OfferBloc offerBloc;

  setUp(() {
    mockGetAllProductUsecase = MockGetAllProductUsecase();
    offerBloc = OfferBloc(getAllProductUsecase: mockGetAllProductUsecase);
  });

  tearDown(() {
    offerBloc.close();
  });

  final products = [
    ProductEntity(
      productId: '1',
      name: 'Discounted Product',
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
    ProductEntity(
      productId: '2',
      name: 'Non-discounted Product',
      categoryId: 'cat2',
      categoryTitle: 'Category2',
      subCategoryId: 'sub2',
      subCategoryTitle: 'SubCategory2',
      brandId: 'brand2',
      brandTitle: 'Brand2',
      price: 200.0,
      image: ['img2.png'],
      description: 'desc2',
      stock: 5,
      shippingCharge: 10.0,
      discount: null,
    ),
  ];

  blocTest<OfferBloc, OfferState>(
    'emits [OfferLoading, OfferLoaded] when LoadDiscountedProducts is added and usecase returns products',
    build: () {
      when(() => mockGetAllProductUsecase()).thenAnswer((_) async => Right(products));
      return offerBloc;
    },
    act: (bloc) => bloc.add(LoadDiscountedProducts()),
    expect: () => [
      OfferLoading(),
      OfferLoaded([products[0]]),
    ],
  );

  blocTest<OfferBloc, OfferState>(
    'emits [OfferLoading, OfferError] when LoadDiscountedProducts is added and usecase returns failure',
    build: () {
      when(() => mockGetAllProductUsecase()).thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'error')));
      return offerBloc;
    },
    act: (bloc) => bloc.add(LoadDiscountedProducts()),
    expect: () => [
      OfferLoading(),
      isA<OfferError>(),
    ],
  );
} 