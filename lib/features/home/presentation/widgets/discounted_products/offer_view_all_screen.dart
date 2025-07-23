import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/dicounted_products_view_model/offer_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/dicounted_products_view_model/offer_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/dicounted_products_view_model/offer_state.dart';
// import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_bloc.dart';
// import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_event.dart';
import 'package:sparexpress/features/home/presentation/widgets/discounted_products/offer_item_card.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_state.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_event.dart';
import 'package:sparexpress/features/home/domin/entity/cart_entity.dart';
import 'package:sparexpress/core/common/snackbar/my_snackbar.dart';
import 'package:sparexpress/features/home/presentation/widgets/product_detail/product_detail_view.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_event.dart';


class OfferViewAllScreen extends StatefulWidget {
  const OfferViewAllScreen({super.key});

  @override
  State<OfferViewAllScreen> createState() => _OfferViewAllScreenState();
}

class _OfferViewAllScreenState extends State<OfferViewAllScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OfferBloc>().add(LoadDiscountedProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'All Offers',
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
        child: BlocBuilder<OfferBloc, OfferState>(
          builder: (context, state) {
            if (state is OfferLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OfferLoaded) {
              final offers = state.discountedProducts;

              if (offers.isEmpty) {
                return const Center(child: Text('No discounted products available'));
              }

              return GridView.builder(
                itemCount: offers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = offers[index];
                  return OfferItemCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider(create: (_) => serviceLocator<ProfileBloc>()..add(FetchCustomerProfile())),
                              BlocProvider(create: (_) => serviceLocator<CartBloc>()..add(LoadCart())),
                            ],
                            child: ProductDetailView(product: product),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is OfferError) {
              return Center(child: Text("Error: "+state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
