import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/widgets/category/category_list_widget.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/category_view_model/category_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/category_view_model/category_state.dart';
import 'package:sparexpress/features/home/domin/entity/category_entity.dart';

class MockCategoryBloc extends Mock implements CategoryBloc {}
class FakeCategoryState extends Fake implements CategoryState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCategoryState());
  });

  testWidgets('shows loading indicator', (tester) async {
    final bloc = MockCategoryBloc();
    when(() => bloc.state).thenReturn(CategoryLoading());
    when(() => bloc.stream).thenAnswer((_) => Stream<CategoryState>.empty());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CategoryBloc>.value(
          value: bloc,
          child: const CategoryListWidget(),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows categories when loaded', (tester) async {
    final bloc = MockCategoryBloc();
    final categories = [
      CategoryEntity(categoryId: '1', categoryTitle: 'Electronics'),
    ];
    when(() => bloc.state).thenReturn(CategoryLoaded(categories));
    when(() => bloc.stream).thenAnswer((_) => Stream<CategoryState>.empty());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CategoryBloc>.value(
          value: bloc,
          child: const CategoryListWidget(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Electronics'), findsOneWidget);
  });

  testWidgets('shows error message', (tester) async {
    final bloc = MockCategoryBloc();
    when(() => bloc.state).thenReturn(CategoryError('error'));
    when(() => bloc.stream).thenAnswer((_) => Stream<CategoryState>.empty());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CategoryBloc>.value(
          value: bloc,
          child: const CategoryListWidget(),
        ),
      ),
    );
    await tester.pump();
    expect(find.textContaining('Error'), findsOneWidget);
  });
} 