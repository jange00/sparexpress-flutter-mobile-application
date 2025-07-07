import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/AllProducts/product_item_card.dart';

class ProductListWidget extends StatelessWidget {
  final bool showAll;
  final VoidCallback? onViewAll;

  const ProductListWidget({
    super.key,
    this.showAll = false,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          final products = state.products;
          if (products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          final displayProducts = showAll ? products : products.take(10).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + View All
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "All Products",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (!showAll && products.length > 10)
                      TextButton(
                        onPressed: onViewAll,
                        child: const Text("View All"),
                      ),
                  ],
                ),
              ),

              SizedBox(
                height: 255,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: displayProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final product = displayProducts[index];
                    return SizedBox(
                      width: 200,
                      child: ProductItemCard(
                        product: product,
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.name} added to cart!')),
                          );
                        },
                        onViewDetail: () {
                          Navigator.pushNamed(
                            context,
                            '/product-detail',
                            arguments: product,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is ProductError) {
          return Center(child: Text("Error: ${state.message}"));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
