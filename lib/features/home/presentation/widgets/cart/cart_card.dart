import 'package:flutter/material.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_event.dart';

class CartCard extends StatelessWidget {
  final CartEntity item;
  final VoidCallback onRemove;

  const CartCard({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Product Image Placeholder (you may want to load product info separately)
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
                image: item.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: item.imageUrl.isEmpty
                  ? const Icon(Icons.shopping_cart, size: 40, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 14),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Price: ₹${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        splashRadius: 18,
                        onPressed: item.quantity > 1
                            ? () {
                                context.read<CartBloc>().add(UpdateCartItem(cartItemId: item.id ?? item.productId, quantity: item.quantity - 1));
                              }
                            : null,
                      ),
                  Text(
                        '${item.quantity}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        splashRadius: 18,
                        onPressed: () {
                          context.read<CartBloc>().add(UpdateCartItem(cartItemId: item.id ?? item.productId, quantity: item.quantity + 1));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove button
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
