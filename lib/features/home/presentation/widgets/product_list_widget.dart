import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/product_item_card.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          // Show loading indicator while products are loading
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          // Show list of products when loaded successfully
          return ListView.builder(
            itemCount: state.products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductItemCard(
                name: product.name,
                images: product.image,
                price: product.price,
                discount: product.discount,
                description: product.description,
                stock: product.stock,
                shippingCharge: product.shippingCharge,
                onAddToCart: () {
                  // TODO: Add your Add to Cart logic here
                },
                onBuyNow: () {
                  // TODO: Add your Buy Now logic here
                },
              );
            },
          );
        } else if (state is ProductError) {
          // Show error message if product loading failed
          return Center(child: Text("Error: ${state.message}"));
        } else {
          // By default, show nothing
          return const SizedBox.shrink();
        }
      },
    );
  }
}
