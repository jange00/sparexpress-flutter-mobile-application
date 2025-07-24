import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/use_case/product/get_product_by_id_usecase.dart';
import 'package:sparexpress/features/home/presentation/view_model/order/order_view_model/order_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/order/order_view_model/order_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/order/order_view_model/order_state.dart';
import 'package:sparexpress/features/home/domin/use_case/shipping/get_all_shipping_addresses_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/app/constant/theme_constant.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';

class OrderView extends StatelessWidget {
  final String userId;

  const OrderView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<OrderBloc>()..add(GetOrdersByUserIdEvent(userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderLoaded) {
              if (state.orders.isEmpty) {
                return const Center(
                  child: Text('No orders found', style: TextStyle(fontSize: 16)),
                );
              }
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return FutureBuilder<ShippingAddressEntity?>(
                    future: _getShippingAddress(context, order.shippingAddressId),
                    builder: (context, addressSnapshot) {
                      final address = addressSnapshot.data;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order Header
                              Row(
                                children: [
                                  Text(
                                    'Order #${order.orderId?.substring(order.orderId!.length - 8) ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const Spacer(),
                                  _StatusChip(order.orderStatus),
                                ],
                              ),
                              const SizedBox(height: 6),
                              if (order.amount != null)
                                Text(
                                  'Total: Rs. ${_formatAmount(order.amount!)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Divider(color: Colors.grey[300]),
                              // Shipping Address
                              const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ThemeConstant.primaryColor)),
                              const SizedBox(height: 4),
                              if (address != null)
                                Text(
                                  '${address.streetAddress}, ${address.city}, ${address.province}, ${address.country}\nPostal: ${address.postalCode}',
                                  style: const TextStyle(fontSize: 14),
                                )
                              else
                                Text(order.shippingAddressId, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                              const SizedBox(height: 10),
                              Divider(color: Colors.grey[300]),
                              // Products List
                              const Text('Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ThemeConstant.primaryColor)),
                              const SizedBox(height: 6),
                              ...order.items.map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item.productName ?? 'Product #${item.productId}',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Qty: ${item.quantity}',
                                        style: const TextStyle(fontSize: 13),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item.productPrice != null ? 'Rs. ${_formatAmount(item.productPrice!)}' : '',
                                        style: const TextStyle(fontSize: 13, color: Colors.deepOrange),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is OrderError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No orders found'));
          },
        ),
      ),
    );
  }

  // Helper to fetch full shipping address
  Future<ShippingAddressEntity?> _getShippingAddress(BuildContext context, String addressId) async {
    final usecase = serviceLocator<GetAllShippingAddressUsecase>();
    final addressesResult = await usecase(userId);
    return addressesResult.fold(
      (failure) => null,
      (addresses) {
        final found = addresses.where((a) => a.id == addressId).cast<ShippingAddressEntity>();
        return found.isNotEmpty ? found.first : null;
      },
    );
  }

  Future<ProductEntity?> _getProductDetails(String productId) async {
    try {
      final usecase = serviceLocator<GetProductByIdUsecase>();
      final result = await usecase(productId);
      return result.fold(
        (failure) => null,
        (product) => product,
      );
    } catch (e) {
      print('Error fetching product details: $e');
      return null;
    }
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

  Widget _buildImageErrorThumb() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 28),
    );
  }
}

// Status chip widget
class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);
  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    Color bg;
    Color fg;
    IconData icon;
    switch (lower) {
      case 'delivered':
        bg = Colors.green[50]!;
        fg = Colors.green[800]!;
        icon = Icons.check_circle_outline;
        break;
      case 'shipped':
        bg = ThemeConstant.primaryColor.withOpacity(0.15);
        fg = ThemeConstant.primaryColor;
        icon = Icons.local_shipping_outlined;
        break;
      case 'processing':
        bg = Colors.orange[50]!;
        fg = Colors.orange[800]!;
        icon = Icons.hourglass_top_rounded;
        break;
      case 'cancelled':
        bg = Colors.red[50]!;
        fg = Colors.red[800]!;
        icon = Icons.cancel_outlined;
        break;
      default:
        bg = Colors.grey[100]!;
        fg = Colors.grey[800]!;
        icon = Icons.info_outline;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 16),
          const SizedBox(width: 4),
          Text(status, style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
