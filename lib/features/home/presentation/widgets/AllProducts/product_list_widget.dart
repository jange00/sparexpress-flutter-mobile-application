import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/constant/api_endpoints.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_state.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_event.dart';
import 'package:sparexpress/features/home/presentation/widgets/AllProducts/product_item_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/AllProducts/product_view_all_screen.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_state.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparexpress/core/common/snackbar/my_snackbar.dart';

class ProductListWidget extends StatelessWidget {
  final bool showAll;

  const ProductListWidget({
    super.key,
    this.showAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>.value(
      value: BlocProvider.of<ProfileBloc>(context),
      child: BlocBuilder<ProductBloc, ProductState>(
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
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<ProductBloc>(
                                    create: (_) => serviceLocator<ProductBloc>()..add(LoadProducts()),
                                  ),
                                  BlocProvider<ProfileBloc>(
                                    create: (_) => serviceLocator<ProfileBloc>()..add(FetchCustomerProfile()),
                                  ),
                                  // CartBloc removed here to use the shared instance
                                ],
                                child: ProductViewAllScreen(),
                              ),
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
                        final cartState = context.read<CartBloc>().state;
                        bool alreadyInCart = false;
                        if (cartState is CartLoaded) {
                          alreadyInCart = cartState.items.any((item) => item.productId == product.productId);
                        }
                        if (alreadyInCart) {
                          showAppSnackBar(
                            context,
                            message: 'Item is already in the cart!',
                            icon: Icons.error_outline,
                            backgroundColor: Colors.red[700],
                          );
                          return;
                        }
                        // Get userId from ProfileBloc if available
                        String userId = '';
                        final profileState = context.read<ProfileBloc>().state;
                        if (profileState is ProfileLoaded) {
                          userId = profileState.customer.customerId ?? '';
                        }
                        final cartEntity = CartEntity(
                          userId: userId,
                          productId: product.productId ?? '',
                          name: product.name,
                          imageUrl: product.image.isNotEmpty ? '${ApiEndpoints.serverAddress}/${product.image.first}' : '',
                          price: product.price,
                          quantity: 1,
                        );
                        context.read<CartBloc>().add(CreateCart(cartEntity));
                        showAppSnackBar(
                          context,
                          message: '${product.name} added to cart!',
                          icon: Icons.check_circle,
                          backgroundColor: Colors.green[700],
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
      ),
    );
  }
}
