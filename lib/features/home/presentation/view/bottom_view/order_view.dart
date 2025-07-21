import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
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
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return ListTile(
                    title: Text('Order ID: ${order.userId}'),
                    subtitle: Text('Total: Rs. ${order.totalAmount}'),
                  );
                },
              );
            } else if (state is OrderError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No orders found'));
          },
        ),
      ),
    );
  }
}
