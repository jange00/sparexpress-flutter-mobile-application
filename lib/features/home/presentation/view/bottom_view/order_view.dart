import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/domin/entity/order_entity.dart';
import 'package:sparexpress/features/home/domin/entity/products_entity.dart';
import 'package:sparexpress/features/home/domin/use_case/product/get_product_by_id_usecase.dart';
import 'package:sparexpress/features/home/presentation/view_model/order/order_view_model/order_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/order/order_view_model/order_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/order/order_view_model/order_state.dart';

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
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Order #${order.orderId?.substring(order.orderId!.length - 8) ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Chip(
                                label: Text(order.orderStatus),
                                backgroundColor: _getStatusColor(order.orderStatus)[0],
                                labelStyle: TextStyle(
                                  color: _getStatusColor(order.orderStatus)[1],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Total Amount and Image
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Total Amount
                                    Text(
                                      'Total Amount: Rs. ${_getOrderTotal(order)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Shipping Address ID
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Shipping Address ID',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            order.shippingAddressId,
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (order.items.isNotEmpty)
                                FutureBuilder<ProductEntity?>(
                                  future: _getProductDetails(order.items.first.productId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey[300]!),
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    
                                    if (snapshot.hasData && snapshot.data?.image != null) {
                                      final imageUrl = snapshot.data!.image.isNotEmpty 
                                          ? snapshot.data!.image[0] 
                                          : null;
                                      
                                      return Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey[300]!),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: imageUrl != null
                                              ? Image.network(
                                                  'http://192.168.1.71:5000/uploads/$imageUrl',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    print('Image error: $error');
                                                    return _buildImageError();
                                                  },
                                                )
                                              : _buildImageError(),
                                        ),
                                      );
                                    }
                                    
                                    return _buildImageError();
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Products List
                          const Text(
                            'Products',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName ?? 'Product #${item.productId}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Qty: ${item.quantity}',
                                    style: const TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
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

  Widget _buildImageError() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.grey[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[400],
            size: 32,
          ),
          const SizedBox(height: 4),
          Text(
            'Image not found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
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



  List<Color> _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return [Colors.green[50]!, Colors.green[800]!];
      case 'shipped':
        return [Colors.blue[50]!, Colors.blue[800]!];
      case 'processing':
        return [Colors.orange[50]!, Colors.orange[800]!];
      case 'cancelled':
        return [Colors.red[50]!, Colors.red[800]!];
      default:
        return [Colors.grey[50]!, Colors.grey[800]!];
    }
  }

  String _getOrderTotal(OrderEntity order) {
    if (order.amount != null) {
      return order.amount!.toStringAsFixed(2);
    }
    // Calculate total from items if order amount is not available
    final total = order.items.fold(0.0, (sum, item) => sum + item.total);
    return total.toStringAsFixed(2);
  }
}
