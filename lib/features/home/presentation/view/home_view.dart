import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/account_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/cart_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_state.dart';
// import 'package:sparexpress/features/home/presentation/widgets/dashboard/dashboard_header/custom_dashboard_appbar.dart';
import 'package:sparexpress/features/home/presentation/widgets/dashboard_header/custom_dashboard_appbar.dart';
import 'package:sparexpress/features/home/presentation/widgets/searchBar/search_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController? _searchController;

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final fullname = state.fullname;

        // Initialize controller only for dashboard
        if (state.selectedIndex == 0 && _searchController == null) {
          _searchController = TextEditingController();
        } else if (state.selectedIndex != 0 && _searchController != null) {
          _searchController!.dispose();
          _searchController = null;
        }

        Widget bodyWidget;
        switch (state.selectedIndex) {
          case 0:
            bodyWidget = const DashboardView();
            break;
          case 1:
            bodyWidget = const Center(child: Text('Order Page'));
            break;
          case 2:
            bodyWidget = const CartView();
            break;
          case 3:
            bodyWidget = const AccountView();
            break;
          default:
            bodyWidget = const DashboardView();
        }

        return Scaffold(
          appBar: state.selectedIndex == 0
              ? CustomDashboardAppBar(fullname: fullname)
              : null,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              children: [
                // Conditionally show search bar only on dashboard
                if (state.selectedIndex == 0 && _searchController != null) ...[
                  SearchBarWidget(
                    controller: _searchController!,
                    onSearch: (query) {
                      print('Searching: $query');
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                Expanded(child: bodyWidget),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Order',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              context.read<HomeViewModel>().onTapped(index);
            },
          ),
        );
      },
    );
  }
}
