import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dicounted_products_view_model/offer_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dicounted_products_view_model/offer_state.dart';
import 'offer_item_card.dart';

class OfferViewAllScreen extends StatelessWidget {
  const OfferViewAllScreen({super.key});

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
            final discountedProducts = state.discountedProducts;

            if (discountedProducts.isEmpty) {
              return const Center(child: Text("No discounted products available."));
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: discountedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = discountedProducts[index];
                  return OfferItemCard(
                    product: product,
                    onTap: () {
                      debugPrint("Tapped on ${product.name}");
                      // TODO: Add navigation to product details here if needed
                    },
                  );
                },
              ),
            );
          } else if (state is OfferError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
