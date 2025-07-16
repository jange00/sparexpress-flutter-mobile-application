import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/widgets/AllProducts/product_list_widget.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_state.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockProductBloc extends Mock implements ProductBloc {}
class FakeProductState extends Fake implements ProductState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeProductState());
  });

  testWidgets('shows loading indicator', (tester) async {
    await mockNetworkImagesFor(() async {
      final bloc = MockProductBloc();
      when(() => bloc.state).thenReturn(ProductLoading());
      when(() => bloc.stream).thenAnswer((_) => Stream<ProductState>.empty());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: bloc,
            child: const ProductListWidget(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('shows products when loaded', (tester) async {
    await mockNetworkImagesFor(() async {
      final bloc = MockProductBloc();
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
      when(() => bloc.state).thenReturn(ProductLoaded(products));
      when(() => bloc.stream).thenAnswer((_) => Stream<ProductState>.empty());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: bloc,
            child: const ProductListWidget(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('All Products'), findsOneWidget);
      expect(find.text('Test Product'), findsOneWidget);
    });
  });

  testWidgets('shows error message', (tester) async {
    await mockNetworkImagesFor(() async {
      final bloc = MockProductBloc();
      when(() => bloc.state).thenReturn(ProductError('error'));
      when(() => bloc.stream).thenAnswer((_) => Stream<ProductState>.empty());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: bloc,
            child: const ProductListWidget(),
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Error'), findsOneWidget);
    });
  });
} 