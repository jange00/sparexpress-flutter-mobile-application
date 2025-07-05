import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/domin/use_case/get_all_product_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductUsecase getAllProducts;

  ProductBloc({required this.getAllProducts}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

 Future<void> _onLoadProducts(
  LoadProducts event,
  Emitter<ProductState> emit,
) async {
  print('LoadProducts event received');

  emit(ProductLoading());

  final result = await getAllProducts();
  print(result);
  

  result.fold(
    (failure) {
      print('Failed to load products: ${failure.message}'); 
      emit(ProductError(failure.message));
    },
    (products) {
      print('Loaded products count: ${products.length}'); 
      emit(ProductLoaded(products));
    },
  );
}
}
