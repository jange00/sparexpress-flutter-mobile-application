import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_state.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CheckoutPage extends StatefulWidget {
  final String userId;
  final String productId;
  final int quantity;
  final String shippingAddressId;

  const CheckoutPage({super.key, required this.userId, required this.productId, required this.quantity, required this.shippingAddressId});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch StartCheckout event after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckoutBloc>().add(StartCheckout(
        userId: widget.userId,
        productId: widget.productId,
        quantity: widget.quantity,
        shippingAddressId: widget.shippingAddressId,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CheckoutReady) {
            // Parse the summary string for display (or, ideally, pass a model)
            final lines = state.summary.split('\n');
            String productName = '', productPrice = '', shipping = '', quantity = '', total = '', address = '', postal = '', productImageUrl = '';
            for (final line in lines) {
              if (line.startsWith('Product:')) productName = line.replaceFirst('Product:', '').trim();
              if (line.startsWith('Price:')) productPrice = line.replaceFirst('Price:', '').trim();
              if (line.startsWith('Shipping:')) shipping = line.replaceFirst('Shipping:', '').trim();
              if (line.startsWith('Quantity:')) quantity = line.replaceFirst('Quantity:', '').trim();
              if (line.startsWith('Total:')) total = line.replaceFirst('Total:', '').trim();
              if (line.startsWith('Shipping Address:')) address = '';
              if (address != '' && line.trim().isNotEmpty && !line.startsWith('Postal Code:')) address += '\n' + line.trim();
              if (line.startsWith('Postal Code:')) postal = line.replaceFirst('Postal Code:', '').trim();
              if (line.startsWith('Image:')) productImageUrl = line.replaceFirst('Image:', '').trim();
              if (line.startsWith('Shipping Address:')) address = '';
            }
            // Fallbacks
            if (address.isEmpty) address = lines.where((l) => l.contains(',')).join('\n');
            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: productImageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: productImageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.shopping_bag, size: 36, color: Colors.deepOrange),
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image, size: 36, color: Colors.grey),
                                    ),
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey[100],
                                    child: const Icon(Icons.shopping_bag, size: 36, color: Colors.deepOrange),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(productPrice, style: const TextStyle(fontSize: 15, color: Colors.deepOrange)),
                                const SizedBox(height: 2),
                                Text('Quantity: $quantity', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Shipping Address Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: Colors.deepOrange, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(address, style: const TextStyle(fontSize: 14)),
                                if (postal.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text('Postal Code: $postal', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Order Summary
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal', style: TextStyle(fontSize: 15)),
                              Text(productPrice, style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping', style: TextStyle(fontSize: 15)),
                              Text(shipping, style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                              Text(total, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CheckoutBloc>().add(ConfirmOrder('cod'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Confirm & Pay'),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CheckoutSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 18),
                  Text('Order placed successfully!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          } else if (state is CheckoutError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 18),
                  Text(state.message, style: const TextStyle(fontSize: 17, color: Colors.red)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 