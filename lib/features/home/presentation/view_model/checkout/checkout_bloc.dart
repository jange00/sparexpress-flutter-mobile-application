import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';
import 'package:sparexpress/features/home/domin/use_case/product/get_product_by_id_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/shipping/get_all_shipping_addresses_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

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
      // Fetch product
      final productResult = await getProductByIdUsecase(event.productId);
      ProductEntity? product;
      productResult.fold((failure) => product = null, (p) => product = p);
      // Fetch shipping address (get all, then find by id)
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
      if (product == null || address == null) {
        emit(CheckoutError('Could not fetch product or address details.'));
        return;
      }
      // Calculate totals
      final discountedPrice = (product!.discount != null && product!.discount! > 0)
          ? product!.price - (product!.price * product!.discount! / 100)
          : product!.price;
      final total = discountedPrice * event.quantity + product!.shippingCharge;
      // Build summary
      final summary = '''
Product: ${product!.name}
Quantity: ${event.quantity}
Price: Rs. ${discountedPrice.toStringAsFixed(2)}
Shipping: Rs. ${product!.shippingCharge.toStringAsFixed(2)}

Shipping Address:
${address!.streetAddress}, ${address!.city}, ${address!.province}, ${address!.country}
Postal Code: ${address!.postalCode}

Total: Rs. ${total.toStringAsFixed(2)}
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