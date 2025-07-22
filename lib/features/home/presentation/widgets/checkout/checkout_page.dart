import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/checkout/checkout_state.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CheckoutReady) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.summary, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CheckoutBloc>().add(ConfirmOrder('cod'));
                    },
                    child: const Text('Confirm & Pay'),
                  ),
                ],
              );
            } else if (state is CheckoutSuccess) {
              return const Center(child: Text('Order placed successfully!'));
            } else if (state is CheckoutError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
} 