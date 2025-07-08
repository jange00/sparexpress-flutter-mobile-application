import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/category_view_model/category_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/category_view_model/category_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/dicounted_products_view_model/offer_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dicounted_products_view_model/offer_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_event.dart';
import 'package:sparexpress/features/home/presentation/widgets/banners/banner_slider.dart';
import 'package:sparexpress/features/home/presentation/widgets/AllProducts/product_list_widget.dart';
import 'package:sparexpress/features/home/presentation/widgets/category/category_list_widget.dart';
import 'package:sparexpress/features/home/presentation/widgets/discounted_products/offer_list_widget.dart';
// import 'package:sparexpress/features/home/presentation/widgets/searchBar/search_bar.dart';
// import 'package:sparexpress/features/home/presentation/widgets/searchBar/search_bar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // final searchController = TextEditingController();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SearchBar
              // SearchBarWidget(
              //   controller: searchController,
              //   onSearch: (query) {
              //     print('Searching: $query');
              //   },
              // ),
              // const SizedBox(height: 12),
              BannerSliderWidget(
                bannerImages: const [
                  'assets/images/banner1.png',
                  'assets/images/wire.jpg',
                ],
              ),

              const SizedBox(height: 12),

              BlocProvider<CategoryBloc>(
                create:
                    (_) =>
                        serviceLocator<CategoryBloc>()..add(LoadCategories()),
                child: const CategoryListWidget(),
              ),

              const SizedBox(height: 12),

              BlocProvider<ProductBloc>(
                create:
                    (_) =>
                        serviceLocator<ProductBloc>()
                          ..add(const LoadProducts()),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                  child: const ProductListWidget(),
                ),
              ),


                const SizedBox(height: 12),

                BlocProvider<OfferBloc>(
                  create:
                      (_) =>
                          serviceLocator<OfferBloc>()
                            ..add(const LoadDiscountedProducts()),
                  child: const OfferListWidget(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
