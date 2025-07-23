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
    return BlocProvider<ProfileBloc>.value(
      value: BlocProvider.of<ProfileBloc>(context),
      child: Scaffold(
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
                        String userId = '';
                        final profileState = context.read<ProfileBloc>().state;
                        if (profileState is ProfileLoaded) {
                          userId = profileState.customer.customerId ?? '';
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User not loaded. Please wait...')),
                          );
                          return;
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
      ),
    );
  }
}
