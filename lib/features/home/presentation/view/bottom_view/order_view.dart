import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/use_case/product/get_product_by_id_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/shipping/get_all_shipping_addresses_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';
import 'package:sparexpress/app/constant/theme_constant.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/features/home/domin/use_case/payment/get_all_payment_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/payment_entity.dart';
import 'package:sparexpress/features/home/domin/use_case/order/get_all_order_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/order/delete_order_usecase.dart';

class OrderView extends StatefulWidget {
  final String userId;
  const OrderView({super.key, required this.userId});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  late Future<_OrdersAndPaymentsResult> _futureData;
  List<OrderEntity> _orders = [];
  Map<String?, dynamic> _paymentMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _futureData = _fetchOrdersAndPayments(context, widget.userId);
    _futureData.then((result) {
      setState(() {
        _orders = result.orders;
        _paymentMap = result.paymentMap;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 24),
                  const Text(
                    'No orders yet!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Looks like you haven\'t placed any orders yet.\nStart shopping and your orders will appear here!',
                    style: TextStyle(fontSize: 15, color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final payment = _paymentMap[order.orderId];
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
                            Row(
                              children: [
                                const Icon(Icons.receipt_long, color: ThemeConstant.primaryColor, size: 22),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Order #${order.orderId?.substring(order.orderId!.length - 8) ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                                  tooltip: 'Copy Order Number',
                                  onPressed: () {
                                    final orderNum = order.orderId ?? '';
                                    if (orderNum.isNotEmpty) {
                                      Clipboard.setData(ClipboardData(text: orderNum));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Order number copied!')),
                                      );
                                    }
                                  },
                                ),
                                _StatusChip(order.orderStatus),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                const Text('Ordered on: 2024-06-10 10:00', style: TextStyle(fontSize: 13, color: Colors.black87)),
                                const SizedBox(width: 16),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.payment, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('Paid via: ${payment?.paymentMethod ?? 'Unknown'}', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(color: Colors.grey[300], thickness: 1.2),
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
                            Row(
                              children: [
                                const Icon(Icons.local_shipping, color: ThemeConstant.primaryColor, size: 18),
                                const SizedBox(width: 6),
                                const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ThemeConstant.primaryColor)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (address != null)
                              Text(
                                '${address.streetAddress}, ${address.city}, ${address.province}, ${address.country}\nPostal: ${address.postalCode}',
                                style: const TextStyle(fontSize: 14),
                              )
                            else
                              Text(order.shippingAddressId, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            const SizedBox(height: 10),
                            Divider(color: Colors.grey[200], thickness: 1),
                            Row(
                              children: [
                                const Icon(Icons.shopping_cart, color: ThemeConstant.primaryColor, size: 18),
                                const SizedBox(width: 6),
                                const Text('Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ThemeConstant.primaryColor)),
                              ],
                            ),
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
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.local_shipping_outlined),
                                    label: const Text('Track Order'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeConstant.primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                                        ),
                                        builder: (context) => _OrderTrackingSheet(orderId: order.orderId ?? 'N/A', status: order.orderStatus),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (order.orderStatus.toLowerCase() != 'delivered' && order.orderStatus.toLowerCase() != 'cancelled')
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.cancel_outlined),
                                      label: const Text('Cancel Order'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[50],
                                        foregroundColor: Colors.red[800],
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Cancel Order'),
                                            content: const Text('Are you sure you want to cancel this order?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          await _cancelOrder(context, order.orderId ?? '');
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<_OrdersAndPaymentsResult> _fetchOrdersAndPayments(BuildContext context, String userId) async {
    final getAllPaymentUsecase = serviceLocator<GetAllPaymentUsecase>();
    final ordersResult = await serviceLocator<GetAllOrderUsecase>()(userId);
    final orders = ordersResult.fold((_) => <OrderEntity>[], (o) => o);
    final paymentsResult = await getAllPaymentUsecase();
    final payments = paymentsResult.fold((_) => <dynamic>[], (p) => p);
    final Map<String?, dynamic> paymentMap = { for (var p in payments) p.orderId: p };
    return _OrdersAndPaymentsResult(orders: orders, paymentMap: paymentMap);
  }

  Future<ShippingAddressEntity?> _getShippingAddress(BuildContext context, String addressId) async {
    final usecase = serviceLocator<GetAllShippingAddressUsecase>();
    final addressesResult = await usecase(widget.userId);
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

  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    try {
      final deleteOrderUsecase = serviceLocator<DeleteOrderUsecase>();
      final result = await deleteOrderUsecase(orderId);
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to cancel order:  [31m${failure.message} [0m')),
          );
        },
        (_) {
          setState(() {
            final idx = _orders.indexWhere((o) => o.orderId == orderId);
            if (idx != -1) {
              final old = _orders[idx];
              _orders[idx] = OrderEntity(
                orderId: old.orderId,
                userId: old.userId,
                amount: old.amount,
                shippingAddressId: old.shippingAddressId,
                orderStatus: 'cancelled',
                items: old.items,
              );
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order cancelled successfully!')),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

class _OrdersAndPaymentsResult {
  final List<OrderEntity> orders;
  final Map<String?, dynamic> paymentMap;
  _OrdersAndPaymentsResult({required this.orders, required this.paymentMap});
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

class OrderEventTimeline {
  final String label;
  final String time;
  OrderEventTimeline({required this.label, required this.time});
}

class OrderTimeline extends StatelessWidget {
  final List<OrderEventTimeline> events;
  final String currentStatus;
  const OrderTimeline({super.key, required this.events, required this.currentStatus});

  int get currentStep {
    final status = currentStatus.toLowerCase();
    if (status == 'delivered') return 3;
    if (status == 'shipped') return 2;
    if (status == 'confirmed' || status == 'processing') return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        Row(
          children: List.generate(events.length, (index) {
            final isActive = index <= currentStep;
            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: isActive ? ThemeConstant.primaryColor : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isActive ? Icons.check : Icons.circle,
                          size: 12,
                          color: isActive ? Colors.white : Colors.grey[500],
                        ),
                      ),
                      if (index < events.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: isActive ? ThemeConstant.primaryColor : Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    events[index].label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isActive ? ThemeConstant.primaryColor : Colors.grey[600],
                    ),
                  ),
                  Text(
                    events[index].time,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _OrderTrackingSheet extends StatelessWidget {
  final String orderId;
  final String status;
  const _OrderTrackingSheet({super.key, required this.orderId, required this.status});

  @override
  Widget build(BuildContext context) {
    // Mock tracking steps
    final steps = [
      {'label': 'Order Placed', 'date': '2024-06-10 10:00'},
      {'label': 'Order Confirmed', 'date': '2024-06-10 11:00'},
      {'label': 'Shipped', 'date': '2024-06-11 09:00'},
      {'label': 'Out for Delivery', 'date': '2024-06-12 13:00'},
      {'label': 'Delivered', 'date': '2024-06-12 15:00'},
    ];
    final isCancelled = status.toLowerCase() == 'cancelled';
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping, color: ThemeConstant.primaryColor),
              const SizedBox(width: 8),
              Text('Tracking for Order #${orderId.substring(orderId.length - 8)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 18),
          ...steps.map((step) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: isCancelled ? Colors.red[300] : ThemeConstant.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      step['label']!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isCancelled ? Colors.red : Colors.black,
                        decoration: isCancelled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      step['date']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isCancelled ? Colors.red : Colors.grey,
                        decoration: isCancelled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
