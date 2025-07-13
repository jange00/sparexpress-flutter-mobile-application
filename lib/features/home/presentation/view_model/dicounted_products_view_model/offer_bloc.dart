import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/domin/use_case/get_all_product_usecase.dart';
import 'offer_event.dart';
import 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final GetAllProductUsecase getAllProductUsecase;

  OfferBloc({required this.getAllProductUsecase}) : super(OfferInitial()) {
    on<LoadDiscountedProducts>(_onLoadDiscountedProducts);
  }

  Future<void> _onLoadDiscountedProducts(
    LoadDiscountedProducts event,
    Emitter<OfferState> emit,
  ) async {
    print('LoadDiscountedProducts event received');

    emit(OfferLoading());

    final result = await getAllProductUsecase();
    print(result);

    result.fold(
      (failure) {
        print('Failed to load offers: ${failure.message}');
        emit(OfferError(failure.message));
      },
      (products) {
        final discounted = products
            .where((product) => product.discount != null && product.discount! > 0)
            .toList();

        print('Loaded discounted products count: ${discounted.length}');
        emit(OfferLoaded(discounted));
      },
    );
  }
}
