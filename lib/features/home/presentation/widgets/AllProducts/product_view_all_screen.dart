import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/AllProducts/product_item_card.dart';

class ProductViewAllScreen extends StatelessWidget {
  const ProductViewAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        centerTitle: true,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              return const Center(child: Text('No products available'));
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItemCard(
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
                  );
                },
              ),
            );
          } else if (state is ProductError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
