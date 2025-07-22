import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/create_cart_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/get_all_cart_usecase.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc(ProductEntity product)
      : super(ProductDetailState(product: product)) {
    on<ProductDetailStarted>((event, emit) {
      emit(state.copyWith(product: event.product, quantity: 1, error: null, addToCartSuccess: false));
    });
    on<ProductDetailQuantityChanged>((event, emit) {
      emit(state.copyWith(quantity: event.quantity, error: null, addToCartSuccess: false));
    });
    on<ProductDetailAddToCart>(_onAddToCart);
  }

  Future<void> _onAddToCart(ProductDetailAddToCart event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(isLoading: true, error: null, addToCartSuccess: false));
    try {
      final prefs = serviceLocator<SharedPreferences>();
      final userId = prefs.getString('userId');
      if (userId == null || userId.isEmpty) {
        emit(state.copyWith(isLoading: false, error: 'User not found. Please login again.'));
        return;
      }
      final getAllCartUsecase = serviceLocator<GetAllCartUsecase>();
      final cartResult = await getAllCartUsecase();
      bool alreadyInCart = false;
      cartResult.fold(
        (failure) {},
        (cartItems) {
          alreadyInCart = cartItems.any((item) => item.productId == state.product.productId);
        },
      );
      if (alreadyInCart) {
        emit(state.copyWith(isLoading: false, error: 'Product is already in cart.', addToCartSuccess: false));
        return;
      }
      final cartEntity = CartEntity(
        userId: userId,
        productId: state.product.productId ?? '',
        name: state.product.name,
        imageUrl: state.product.image.isNotEmpty ? state.product.image.first : '',
        price: state.product.price,
        quantity: event.quantity,
      );
      final createCartUsecase = serviceLocator<CreateCartUsecase>();
      final result = await createCartUsecase(cartEntity);
      result.fold(
        (failure) {
          emit(state.copyWith(isLoading: false, error: 'Failed to add to cart: ${failure.message}', addToCartSuccess: false));
        },
        (_) {
          emit(state.copyWith(isLoading: false, error: null, addToCartSuccess: true));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString(), addToCartSuccess: false));
    }
  }
} 