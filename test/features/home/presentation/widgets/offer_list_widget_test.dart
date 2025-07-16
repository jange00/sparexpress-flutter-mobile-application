import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/widgets/discounted_products/offer_list_widget.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/dicounted_products_view_model/offer_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/dicounted_products_view_model/offer_state.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';

class MockOfferBloc extends Mock implements OfferBloc {}
class FakeOfferState extends Fake implements OfferState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeOfferState());
  });

  testWidgets('shows loading indicator', (tester) async {
    final bloc = MockOfferBloc();
    when(() => bloc.state).thenReturn(OfferLoading());
    when(() => bloc.stream).thenAnswer((_) => Stream<OfferState>.empty());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OfferBloc>.value(
          value: bloc,
          child: const OfferListWidget(),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows offers when loaded', (tester) async {
    final bloc = MockOfferBloc();
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
    ];
    when(() => bloc.state).thenReturn(OfferLoaded(products));
    when(() => bloc.stream).thenAnswer((_) => Stream<OfferState>.empty());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OfferBloc>.value(
          value: bloc,
          child: const OfferListWidget(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Special Offers'), findsOneWidget);
    expect(find.text('Discounted Product'), findsOneWidget);
  });

  testWidgets('shows error message', (tester) async {
    final bloc = MockOfferBloc();
    when(() => bloc.state).thenReturn(OfferError('error'));
    when(() => bloc.stream).thenAnswer((_) => Stream<OfferState>.empty());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OfferBloc>.value(
          value: bloc,
          child: const OfferListWidget(),
        ),
      ),
    );
    await tester.pump();
    expect(find.textContaining('error'), findsOneWidget);
  });
} 