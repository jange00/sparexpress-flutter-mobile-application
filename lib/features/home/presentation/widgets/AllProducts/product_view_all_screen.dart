import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/AllProducts/product_item_card.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_event.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_state.dart';
import 'package:sparexpress/core/common/snackbar/my_snackbar.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_state.dart';

class ProductViewAllScreen extends StatefulWidget {
  const ProductViewAllScreen({super.key});

  @override
  State<ProductViewAllScreen> createState() => _ProductViewAllScreenState();
}

class _ProductViewAllScreenState extends State<ProductViewAllScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'All Products',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepOrange,
        elevation: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // TODO: Navigate to cart page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState is! ProfileLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  final products = state.products;

                  if (products.isEmpty) {
                    return const Center(child: Text('No products available'));
                  }

                  return GridView.builder(
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
                          String userId = '';
                          final profileState = context.read<ProfileBloc>().state;
                          if (profileState is ProfileLoaded) {
                            userId = profileState.customer.customerId ?? '';
                          }
                          final cartEntity = CartEntity(
                            userId: userId,
                            productId: product.productId ?? '',
                            name: product.name,
                            imageUrl: product.image.isNotEmpty ? 'http://localhost:3000/${product.image.first}' : '',
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
                  );
                } else if (state is ProductError) {
                  return Center(child: Text("Error: "+state.message));
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
