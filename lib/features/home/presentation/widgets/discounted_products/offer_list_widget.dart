import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/dicounted_products_view_model/offer_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dicounted_products_view_model/offer_state.dart';
// import 'package:sparexpress/features/home/presentation/widgets/discounted_products/OfferViewAllScreen.dart';
import 'package:sparexpress/features/home/presentation/widgets/discounted_products/offer_view_all_screen.dart';
import 'offer_item_card.dart';

class OfferListWidget extends StatelessWidget {
  final VoidCallback? onViewAll;

  const OfferListWidget({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferBloc, OfferState>(
      builder: (context, state) {
        if (state is OfferLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OfferLoaded) {
          final discountedProducts = state.discountedProducts;

          if (discountedProducts.isEmpty) {
            return const Center(
              child: Text("No discounted products available."),
            );
          }

          final latestFour =
              discountedProducts.length > 4
                  ? discountedProducts.sublist(0, 4)
                  : discountedProducts;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row with "Special Offers" and "View All" button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Special Offers",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (discountedProducts.length > 4)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider.value(
                                      value: serviceLocator<OfferBloc>(),
                                      child: const OfferViewAllScreen(),
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            "View All",
                            // style: TextStyle(color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: latestFour.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                    itemBuilder: (context, index) {
                      final product = latestFour[index];
                      return OfferItemCard(
                        product: product,
                        onTap: () {
                          debugPrint("Tapped on ${product.name}");
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is OfferError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
