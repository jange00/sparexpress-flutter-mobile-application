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
      appBar: AppBar(
        title: const Text('All Offers'),
        centerTitle: true,
      ),
      body: BlocBuilder<OfferBloc, OfferState>(
        builder: (context, state) {
          if (state is OfferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OfferLoaded) {
            final offers = state.discountedProducts;

            if (offers.isEmpty) {
              return const Center(child: Text('No discounted products available'));
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
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
              ),
            );
          } else if (state is OfferError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
