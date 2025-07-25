// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sparexpress/features/home/presentation/widgets/cart/cart_model.dart';

// import 'cart_event.dart';
// import 'cart_state.dart';

// class CartBloc extends Bloc<CartEvent, CartState> {
//   CartBloc() : super(CartInitial()) {
//     // Load Cart Items
//     on<LoadCart>((event, emit) {
//       final List<CartItem> items = [
//         CartItem(
//           productId: '1',
//           name: 'Wireless Controller for PS4™',
//           price: 64.99,
//           quantity: 2,
//           imageUrl: 'https://via.placeholder.com/60',
//         ),
//         CartItem(
//           productId: '2',
//           name: 'Logitech Zone Wireless Headset',
//           price: 90.00,
//           quantity: 1,
//           imageUrl: 'https://via.placeholder.com/60',
//         ),
//         CartItem(
//           productId: '3',
//           name: 'Nike Joyride Run Flyknit',
//           price: 131.18,
//           quantity: 1,
//           imageUrl: 'https://via.placeholder.com/60',
//         ),
//       ];

//       final double total = items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

//       emit(CartLoaded(items: items, total: total));
//     });

//     // Remove Cart Item
//     on<RemoveCartItem>((event, emit) {
//       if (state is CartLoaded) {
//         final current = (state as CartLoaded);
//         final updatedItems =
//             current.items.where((item) => item.productId != event.productId).toList();

//         final double updatedTotal =
//             updatedItems.fold(0.0, (sum, item) => sum + item.price * item.quantity);

//         emit(CartLoaded(items: updatedItems, total: updatedTotal));
//       }
//     });
//   }
// }


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/get_all_cart_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/create_cart_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/delete_cart_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/update_cart_item_usecase.dart';
// import 'package:sparexpress/features/home/domin/usecase/cart_usecases/get_all_cart_usecase.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetAllCartUsecase getAllCartUsecase;
  final CreateCartUsecase createCartUsecase;
  final DeleteCartUsecase deleteCartUsecase;
  final UpdateCartItemUsecase updateCartItemUsecase;

  CartBloc({
    required this.getAllCartUsecase,
    required this.createCartUsecase,
    required this.deleteCartUsecase,
    required this.updateCartItemUsecase,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<CreateCart>(_onCreateCart);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<UpdateCartItem>(_onUpdateCartItem);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    print("cart bloc called");
    emit(CartLoading());
    final result = await getAllCartUsecase();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cartItems) {
        final total = cartItems.fold<double>(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        );
        emit(CartLoaded(items: cartItems, total: total));
      },
    );
  }

  Future<void> _onCreateCart(CreateCart event, Emitter<CartState> emit) async {
    emit(CartCreating());
    final result = await createCartUsecase(event.cart);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) async {
        emit(CartCreated());
        // Immediately reload the cart for up-to-date state
        add(LoadCart());
      },
    );
  }

  Future<void> _onRemoveCartItem(RemoveCartItem event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final current = state as CartLoaded;
      final updatedItems = current.items.where((item) => item.productId != event.productId).toList();
      final updatedTotal = updatedItems.fold(0.0, (sum, item) => sum + item.price * item.quantity);
      // Emit updated state immediately for instant UI update
      emit(CartLoaded(items: updatedItems, total: updatedTotal));
    }
    // Then perform the backend removal
    final result = await deleteCartUsecase(event.productId);
    await result.fold(
      (failure) async {
        emit(CartError(failure.message));
      },
      (_) async {
        // Optionally reload from backend to ensure consistency
        add(LoadCart());
      },
    );
  }

  Future<void> _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await updateCartItemUsecase(event.cartItemId, event.quantity);
    await result.fold(
      (failure) async {
        emit(CartError(failure.message));
      },
      (_) async {
        final cartResult = await getAllCartUsecase();
        await cartResult.fold(
          (failure) async {
            emit(CartError(failure.message));
          },
          (cartItems) async {
            final total = cartItems.fold<double>(
              0.0,
              (sum, item) => sum + (item.price * item.quantity),
            );
            emit(CartLoaded(items: cartItems, total: total));
          },
        );
      },
    );
  }
}
