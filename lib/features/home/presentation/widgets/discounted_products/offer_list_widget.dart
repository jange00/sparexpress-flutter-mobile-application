import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/dicounted_products_view_model/offer_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/dicounted_products_view_model/offer_state.dart';
// import 'package:sparexpress/features/home/presentation/widgets/discounted_products/OfferViewAllScreen.dart';
import 'package:sparexpress/features/home/presentation/widgets/discounted_products/offer_view_all_screen.dart';
import 'offer_item_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/product_detail/product_detail_view.dart';
import 'package:shimmer/shimmer.dart';

class OfferListWidget extends StatelessWidget {
  final VoidCallback? onViewAll;

  const OfferListWidget({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferBloc, OfferState>(
      builder: (context, state) {
        if (state is OfferLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
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
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 16,
                          width: 100,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 6),
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
                          debugPrint('Tapped special offer: ${product.name}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailView(product: product),
                            ),
                          );
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
