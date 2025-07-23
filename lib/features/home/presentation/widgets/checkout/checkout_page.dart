import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_state.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';

class CheckoutPage extends StatefulWidget {
  final String userId;
  final List<CartEntity> cartItems;
  final String shippingAddressId;

  const CheckoutPage({
    super.key,
    required this.userId,
    required this.cartItems,
    required this.shippingAddressId,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPayment = 'esewa';
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'key': 'esewa',
      'label': 'eSewa',
      'icon': Icons.account_balance_wallet,
      'color': Color(0xFF1EB564),
    },
    {
      'key': 'khalti',
      'label': 'Khalti',
      'icon': Icons.account_balance,
      'color': Color(0xFF5F259F),
    },
    {
      'key': 'bank',
      'label': 'Bank',
      'icon': Icons.account_balance_outlined,
      'color': Color(0xFF1565C0),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckoutBloc>().add(StartCheckout(
        userId: widget.userId,
        cartItems: widget.cartItems,
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
            // Parse the summary string for all products and order info
            final lines = state.summary.split('\n');
            List<Map<String, String>> products = [];
            Map<String, String> currentProduct = {};
            String address = '', postal = '', subtotal = '', totalShipping = '', total = '';
            bool inProductSection = false;
            bool inAddressSection = false;
            for (final line in lines) {
              if (line.startsWith('Product:')) {
                if (currentProduct.isNotEmpty) {
                  products.add(Map<String, String>.from(currentProduct));
                  currentProduct.clear();
                }
                currentProduct['name'] = line.replaceFirst('Product:', '').trim();
                inProductSection = true;
                inAddressSection = false;
              } else if (inProductSection && line.startsWith('Quantity:')) {
                currentProduct['quantity'] = line.replaceFirst('Quantity:', '').trim();
              } else if (inProductSection && line.startsWith('Price:')) {
                currentProduct['price'] = line.replaceFirst('Price:', '').trim();
              } else if (inProductSection && line.startsWith('Shipping:')) {
                currentProduct['shipping'] = line.replaceFirst('Shipping:', '').trim();
              } else if (inProductSection && line.startsWith('Image:')) {
                currentProduct['image'] = line.replaceFirst('Image:', '').trim();
              } else if (line.trim().isEmpty && inProductSection) {
                if (currentProduct.isNotEmpty) {
                  products.add(Map<String, String>.from(currentProduct));
                  currentProduct.clear();
                }
                inProductSection = false;
              } else if (line.startsWith('Shipping Address:')) {
                inProductSection = false;
                inAddressSection = true;
                address = '';
              } else if (inAddressSection && line.startsWith('Postal Code:')) {
                postal = line.replaceFirst('Postal Code:', '').trim();
                inAddressSection = false;
              } else if (inAddressSection && line.trim().isNotEmpty) {
                address += (address.isEmpty ? '' : '\n') + line.trim();
              } else if (line.startsWith('Subtotal:')) {
                subtotal = line.replaceFirst('Subtotal:', '').trim();
              } else if (line.startsWith('Total Shipping:')) {
                totalShipping = line.replaceFirst('Total Shipping:', '').trim();
              } else if (line.startsWith('Total:')) {
                total = line.replaceFirst('Total:', '').trim();
              }
            }
            if (currentProduct.isNotEmpty) {
              products.add(Map<String, String>.from(currentProduct));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Cards
                  ...products.map((product) => Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: product['image'] != null && product['image']!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: product['image']!,
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
                                    Text(product['name'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(product['price'] ?? '', style: const TextStyle(fontSize: 15, color: Colors.deepOrange)),
                                    const SizedBox(height: 2),
                                    Text('Quantity: ${product['quantity'] ?? ''}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                    if (product['shipping'] != null && product['shipping']!.isNotEmpty)
                                      Text('Shipping: ${product['shipping']}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
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
                              Text(subtotal, style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping', style: TextStyle(fontSize: 15)),
                              Text(totalShipping, style: const TextStyle(fontSize: 15)),
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
                  // Payment Method Selection
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _paymentMethods.map((method) {
                            final isSelected = _selectedPayment == method['key'];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPayment = method['key'];
                                });
                              },
                              child: Card(
                                color: isSelected ? method['color'].withOpacity(0.15) : Colors.white,
                                elevation: isSelected ? 4 : 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected ? method['color'] : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                  child: Column(
                                    children: [
                                      Icon(method['icon'], color: method['color'], size: 32),
                                      const SizedBox(height: 6),
                                      Text(method['label'], style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? method['color'] : Colors.black87)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CheckoutBloc>().add(ConfirmOrder(_selectedPayment));
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