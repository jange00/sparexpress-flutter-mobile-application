import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/domin/use_case/get-all_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoryUsecase getAllCategoryUsecase;

  CategoryBloc({required this.getAllCategoryUsecase}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    print('LoadCategories event received');

    emit(CategoryLoading());

    final result = await getAllCategoryUsecase();
    print(result);

    result.fold(
      (failure) {
        print('Failed to load categories: ${failure.message}');
        emit(CategoryError(failure.message));
      },
      (categories) {
        print('Loaded categories count: ${categories.length}');
        emit(CategoryLoaded(categories));
      },
    );
  }
}
