import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/AllProducts/product_item_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/AllProducts/product_view_all_screen.dart';
import 'package:shimmer/shimmer.dart';

class ProductListWidget extends StatelessWidget {
  final bool showAll;

  const ProductListWidget({
    super.key,
    this.showAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 170,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.13),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 90,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 16,
                          width: 100,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 2),
                        Container(
                          height: 14,
                          width: 60,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 28,
                          width: 80,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is ProductLoaded) {
          final products = state.products;
          if (products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          final displayProducts = showAll ? products : products.take(4).toList();

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
                    if (!showAll && products.length > 4)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(value: serviceLocator<ProductBloc>(),child: ProductViewAllScreen(),),
                            ),
                          );
                        },
                        child: const Text("View All"),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = displayProducts[index];
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
