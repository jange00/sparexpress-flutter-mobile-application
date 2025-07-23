import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';
import 'package:sparexpress/features/home/domin/use_case/product/get_product_by_id_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/shipping/get_all_shipping_addresses_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/domin/use_case/order/create_order_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/payment/create_payment_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';
import 'package:sparexpress/features/home/data/repository/remote_repository/cart_remote_repostiory.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final GetProductByIdUsecase getProductByIdUsecase;
  final GetAllShippingAddressUsecase getAllShippingAddressUsecase;

  // Store checkout info for order/payment creation
  List<CartEntity> _lastCartItems = [];
  String _lastUserId = '';
  String _lastShippingAddressId = '';
  double _lastTotal = 0.0;

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
      // Store for order/payment creation
      _lastCartItems = event.cartItems;
      _lastUserId = event.userId;
      _lastShippingAddressId = event.shippingAddressId;
      _lastTotal = grandTotal;
      emit(CheckoutReady(summary));
    } catch (e) {
      emit(CheckoutError('Failed to load checkout details: $e'));
    }
  }

  Future<void> _onConfirmOrder(ConfirmOrder event, Emitter emit) async {
    emit(CheckoutLoading());
    try {
      // 1. Create OrderEntity
      final orderItems = _lastCartItems.map((cart) => OrderItemEntity(
        productId: cart.productId,
        productName: cart.name,
        productImage: cart.imageUrl,
        productPrice: cart.price,
        quantity: cart.quantity,
        total: cart.price * cart.quantity,
      )).toList();
      final order = OrderEntity(
        userId: _lastUserId,
        amount: _lastTotal,
        shippingAddressId: _lastShippingAddressId,
        orderStatus: 'pending',
        items: orderItems,
      );
      final createOrderUsecase = serviceLocator<CreateOrderUsecase>();
      final orderResult = await createOrderUsecase(order);
      if (orderResult.isLeft()) {
        final failure = orderResult.fold((f) => f, (_) => null);
        emit(CheckoutError('Order creation failed: ${failure?.message ?? ''}'));
        return;
      }
      final createdOrder = orderResult.fold((_) => null, (o) => o);
      // 2. Create PaymentEntity
      String mappedPaymentMethod;
      switch (event.paymentMethod) {
        case 'cod':
          mappedPaymentMethod = 'Cash on Delivery';
          break;
        case 'esewa':
          mappedPaymentMethod = 'Esewa';
          break;
        case 'khalti':
          mappedPaymentMethod = 'Khalti';
          break;
        case 'bank':
          mappedPaymentMethod = 'Bank';
          break;
        default:
          mappedPaymentMethod = event.paymentMethod;
      }
      String mappedPaymentStatus = event.paymentMethod == 'cod' ? 'Pending' : 'Paid';
      final payment = PaymentEntity(
        userId: _lastUserId,
        orderId: createdOrder?.orderId ?? '',
        amount: _lastTotal,
        paymentMethod: mappedPaymentMethod,
        paymentStatus: mappedPaymentStatus,
      );
      final createPaymentUsecase = serviceLocator<CreatePaymentUsecase>();
      final paymentResult = await createPaymentUsecase(payment);
      if (paymentResult.isLeft()) {
        final failure = paymentResult.fold((f) => f, (_) => null);
        emit(CheckoutError('Payment creation failed: ${failure?.message ?? ''}'));
        return;
      }
      // 3. Clear cart for the user
      final cartRepo = serviceLocator<CartRemoteRepository>();
      try {
        await cartRepo.clearCartByUserId(_lastUserId);
      } catch (e) {
        // Log error but proceed
      }
      emit(CheckoutSuccess());
    } catch (e) {
      emit(CheckoutError('Failed to place order: $e'));
    }
  }
} 