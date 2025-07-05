import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
// import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/product_view_model/product_event.dart';
import 'package:sparexpress/features/home/presentation/widgets/product_list_widget.dart';
import 'package:sparexpress/features/home/presentation/widgets/search_bar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
Widget build(BuildContext context) {
  final searchController = TextEditingController();

  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          SearchBarWidget(
            controller: searchController,
            onSearch: (query) {
              print('Searching: $query');
            },
          ),
          // const SizedBox(height: 12),
           // // Banner Slider
                  // BannerSliderWidget(
                  //   bannerImages: const [
                  //     'assets/images/mouse.jpg',
                  //     'assets/images/wire.jpg',
                  //   ],
                  // ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              color: Colors.blueGrey.withOpacity(0.1),
              child: BlocProvider<ProductBloc>(
                create: (_) =>
                    serviceLocator<ProductBloc>()..add(const LoadProducts()),
                child: const ProductListWidget(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}