import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
// import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/cart/cart_card.dart';

class CartListView extends StatelessWidget {
  const CartListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CartLoaded) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return CartCard(
                item: item,
                onRemove: () {
                  // TODO: Add RemoveCartItem event when implemented
                },
              );
            },
          );
        } else if (state is CartError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
