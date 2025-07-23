import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';
import 'package:sparexpress/features/home/domin/use_case/product/get_product_by_id_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/shipping/get_all_shipping_addresses_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final GetProductByIdUsecase getProductByIdUsecase;
  final GetAllShippingAddressUsecase getAllShippingAddressUsecase;

  CheckoutBloc({required this.getProductByIdUsecase, required this.getAllShippingAddressUsecase}) : super(CheckoutInitial()) {
    on<StartCheckout>(_onStartCheckout);
    on<ConfirmOrder>(_onConfirmOrder);
  }

  Future<void> _onStartCheckout(StartCheckout event, Emitter emit) async {
    emit(CheckoutLoading());
    try {
      final addressResult = await getAllShippingAddressUsecase(event.userId);
      ShippingAddressEntity? address;
      addressResult.fold(
        (failure) => address = null,
        (list) {
          try {
            address = list.firstWhere((a) => a.id == event.shippingAddressId);
          } catch (_) {
            address = null;
          }
        },
      );
      if (address == null) {
        emit(CheckoutError('Could not fetch address details.'));
        return;
      }
      double subtotal = 0.0;
      double totalShipping = 0.0;
      String productsSummary = '';
      for (final cartItem in event.cartItems) {
        final productResult = await getProductByIdUsecase(cartItem.productId);
        ProductEntity? product;
        productResult.fold((failure) => product = null, (p) => product = p);
        if (product == null) {
          emit(CheckoutError('Could not fetch details for product: ${cartItem.name}'));
          return;
        }
        final discountedPrice = (product!.discount != null && product!.discount! > 0)
            ? product!.price - (product!.price * product!.discount! / 100)
            : product!.price;
        subtotal += discountedPrice * cartItem.quantity;
        totalShipping += product!.shippingCharge * cartItem.quantity;
        String imageUrl = '';
        if (product!.image.isNotEmpty) {
          imageUrl = product!.image.first.startsWith('http')
              ? product!.image.first
              : 'http://localhost:3000/${product!.image.first}';
        }
        productsSummary += '''
Product: ${product!.name}
Quantity: ${cartItem.quantity}
Price: Rs. ${discountedPrice.toStringAsFixed(2)}
Shipping: Rs. ${product!.shippingCharge.toStringAsFixed(2)}
${imageUrl.isNotEmpty ? 'Image: $imageUrl\n' : ''}
''';
      }
      final grandTotal = subtotal + totalShipping;
      final summary = '''
Order Details:
$productsSummary
Shipping Address:
${address!.streetAddress}, ${address!.city}, ${address!.province}, ${address!.country}
Postal Code: ${address!.postalCode}

Subtotal: Rs. ${subtotal.toStringAsFixed(2)}
Total Shipping: Rs. ${totalShipping.toStringAsFixed(2)}
Total: Rs. ${grandTotal.toStringAsFixed(2)}
''';
      emit(CheckoutReady(summary));
    } catch (e) {
      emit(CheckoutError('Failed to load checkout details: $e'));
    }
  }

  Future<void> _onConfirmOrder(ConfirmOrder event, Emitter emit) async {
    emit(CheckoutLoading());
    // Call payment/order usecase
    emit(CheckoutSuccess());
  }
} 