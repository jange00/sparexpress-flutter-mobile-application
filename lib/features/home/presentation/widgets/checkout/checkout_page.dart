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
import 'dart:ui';
import 'package:flutter_paypal/flutter_paypal.dart';

// Top-level SectionHeader widget for visual hierarchy
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
    child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, letterSpacing: 0.2)),
  );
}

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
      'icon': null,
      'color': Color(0xFF1EB564), // eSewa green
      'logoUrl': 'https://media.licdn.com/dms/image/sync/v2/D4D27AQG8vY0HJvndiA/articleshare-shrink_800/articleshare-shrink_800/0/1734856652596?e=2147483647&v=beta&t=Bv2nRIjUfQqm01SIrVrfe4kBIeZLA-FAAf4RgwbKpMg',
    },
    {
      'key': 'khalti',
      'label': 'Khalti',
      'icon': null,
      'color': Color(0xFF5F259F),
      'logoUrl': 'https://blog.khalti.com/wp-content/uploads/2021/01/khalti-icon.png',
    },
    {
      'key': 'bank',
      'label': 'Bank',
      'icon': Icons.account_balance_outlined,
      'color': Color(0xFF1565C0),
    },
    {
      'key': 'cod',
      'label': 'COD',
      'icon': Icons.money,
      'color': Color(0xFF795548),
    },
    {
      'key': 'paypal',
      'label': 'PayPal',
      'icon': null, // We'll use a logo image
      'color': Color(0xFF003087),
      'logoUrl': 'https://www.paypalobjects.com/webstatic/icon/pp258.png',
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
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            showGeneralDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.black.withOpacity(0.4),
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, anim1, anim2) {
                Future.delayed(const Duration(seconds: 2), () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).popUntil((route) => route.isFirst); // Go to dashboard
                  }
                });
                return SafeArea(
                  child: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                      Center(
                        child: Card(
                          elevation: 16,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 44),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(milliseconds: 700),
                                  builder: (context, value, child) {
                                    return Icon(Icons.check_circle_rounded,
                                      color: Colors.green.withOpacity(value),
                                      size: 90 * value,
                                    );
                                  },
                                ),
                                const SizedBox(height: 18),
                                const Text('Order Placed!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green)),
                                const SizedBox(height: 10),
                                const Text('Thank you for shopping with us.', style: TextStyle(fontSize: 17, color: Colors.black54)),
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.circle, color: Colors.orange, size: 10),
                                    const SizedBox(width: 6),
                                    Icon(Icons.circle, color: Colors.purple, size: 12),
                                    const SizedBox(width: 6),
                                    Icon(Icons.circle, color: Colors.blue, size: 8),
                                    const SizedBox(width: 6),
                                    Icon(Icons.circle, color: Colors.red, size: 10),
                                    const SizedBox(width: 6),
                                    Icon(Icons.circle, color: Colors.green, size: 12),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                const CircularProgressIndicator(color: Colors.green),
                                const SizedBox(height: 10),
                                const Text('Redirecting to dashboard...', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader('Order Items'),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final product = products[i];
                          return Container(
                            width: 220,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: product['image'] != null && product['image']!.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: product['image']!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) => Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[200],
                                              child: const Icon(Icons.shopping_bag, size: 30, color: Colors.deepOrange),
                                            ),
                                            errorWidget: (_, __, ___) => Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[200],
                                              child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                                            ),
                                          )
                                        : Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[100],
                                            child: const Icon(Icons.shopping_bag, size: 30, color: Colors.deepOrange),
                                          ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(product['name'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 2),
                                          Text(product['price'] ?? '', style: const TextStyle(fontSize: 15, color: Colors.deepOrange)),
                                          Text('Qty: ${product['quantity'] ?? ''}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SectionHeader('Shipping Address'),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.deepOrange, size: 28),
                        title: const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address, style: const TextStyle(fontSize: 14)),
                            if (postal.isNotEmpty) Text('Postal Code: $postal', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.deepOrange),
                          onPressed: () {/* TODO: Implement address edit */},
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SectionHeader('Order Summary'),
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
                    const SizedBox(height: 24),
                    const SectionHeader('Payment Method'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _paymentMethods.map((method) {
                          final isSelected = _selectedPayment == method['key'];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPayment = method['key'];
                                });
                              },
                              child: Card(
                                color: isSelected ? method['color'].withOpacity(0.15) : Colors.white,
                                elevation: isSelected ? 6 : 1,
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
                                      method['logoUrl'] != null
                                          ? Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: method['key'] == 'esewa' ? method['color'] : Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    method['logoUrl'],
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Icon(method['icon'], color: method['color'], size: 32),
                                      const SizedBox(height: 6),
                                      Text(method['label'], style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? method['color'] : Colors.black87)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is CheckoutLoading ? null : () async {
                          if (_selectedPayment == 'esewa') {
                            // TODO: Implement eSewa payment integration (WebView)
                            // Show a dialog or WebView for eSewa payment
                          } else if (_selectedPayment == 'khalti') {
                            // TODO: Implement Khalti payment integration
                          } else if (_selectedPayment == 'bank') {
                            // TODO: Show bank transfer instructions or placeholder
                          } else if (_selectedPayment == 'cod') {
                            // Cash on Delivery: Show success dialog and confirm order immediately
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Order Placed'),
                                content: const Text('Your order has been placed with Cash on Delivery.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            context.read<CheckoutBloc>().add(ConfirmOrder('cod'));
                          } else if (_selectedPayment == 'paypal') {
                            // PayPal payment integration using actual cartItems
                            final cartItems = widget.cartItems;
                            if (cartItems.isEmpty) return;
                            // Example conversion rate: 1 USD = 132 NPR
                            const nprToUsd = 132.0;
                            final items = cartItems.map((item) => {
                              "name": (item.name ?? '').toString(),
                              "quantity": (item.quantity ?? 1).toString(),
                              "price": ((item.price ?? 0.0) / nprToUsd).toStringAsFixed(2),
                              "currency": "USD",
                            }).toList();
                            final subtotal = items.fold<double>(
                              0.0,
                              (sum, item) => sum + double.parse((item["price"] ?? '0.00').toString()) * int.parse((item["quantity"] ?? '1').toString()),
                            );
                            final subtotalStr = subtotal.toStringAsFixed(2);
                            final title = cartItems.length == 1 ? cartItems[0].name ?? '' : 'Multiple Products';
                            print('PayPal subtotalStr: $subtotalStr, items: $items');
                            if (subtotal <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Cannot pay zero amount!')),
                              );
                              return;
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => UsePaypal(
                                  sandboxMode: true,
                                  clientId: "AcnpbvL-nqay69eboBK-a2hcQLnkFTQZXbTF0f4UafVwhRYAXe11Z0B3PtFyWCTDH24INY6Cu2U0rhRC",
                                  secretKey: "EGZXWncK71BKAfqH7ClPpldekK6kSKvO9yIk0Loz36CkdM7uLC_vuE5mjbGjRhJhBT5BeOYyBB-_p6WW",
                                  returnURL: "https://samplesite.com/return",
                                  cancelURL: "https://samplesite.com/cancel",
                                  transactions: [
                                    {
                                      "amount": {
                                        "total": subtotalStr,
                                        "currency": "USD",
                                        "details": {
                                          "subtotal": subtotalStr,
                                          "shipping": "0.00",
                                          "shipping_discount": "0.00",
                                        },
                                      },
                                      "description": "Payment for product: $title",
                                      "item_list": {
                                        "items": items,
                                      },
                                    },
                                  ],
                                  note: "Contact us for any questions on your order.",
                                  onSuccess: (Map params) async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('PayPal payment successful!')),
                                    );
                                    context.read<CheckoutBloc>().add(ConfirmOrder('paypal'));
                                  },
                                  onError: (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('PayPal payment error: $error')),
                                    );
                                  },
                                  onCancel: (params) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('PayPal payment cancelled')),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: state is CheckoutLoading
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Confirm & Pay'),
                      ),
                    ),
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
      ),
    );
  }
} 