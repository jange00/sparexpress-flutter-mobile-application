import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/account_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/cart_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/order_view.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_state.dart';
// import 'package:sparexpress/features/home/presentation/widgets/dashboard/dashboard_header/custom_dashboard_appbar.dart';
import 'package:sparexpress/features/home/presentation/widgets/dashboard_header/custom_dashboard_appbar.dart';
import 'package:sparexpress/features/home/presentation/widgets/searchBar/search_bar.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_state.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_state.dart';

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
    return BlocProvider(
      create: (_) => serviceLocator<CartBloc>()..add(LoadCart()),
      child: BlocProvider(
      create: (_) => serviceLocator<ProfileBloc>()..add(FetchCustomerProfile()),
      child: BlocBuilder<HomeViewModel, HomeState>(
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
              bodyWidget = BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                  if (profileState is ProfileLoaded) {
                    final userId = profileState.customer.customerId ?? '';
                    return OrderView(userId: userId);
                  } else if (profileState is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (profileState is ProfileError) {
                    return Center(child: Text('Error: ${profileState.message}'));
                  } else {
                    return const Center(child: Text('Loading user...'));
                  }
                },
              );
              break;
            case 2:
              bodyWidget = const CartView();
              break;
            case 3:
              bodyWidget = BlocProvider(
                create: (context) => AccountBloc(context: context),
                child: AccountView(),
              );
              break;
            default:
              bodyWidget = const DashboardView();
          }

          return Scaffold(
            appBar: state.selectedIndex == 0
                ? CustomDashboardAppBar()
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
            // --- Enhanced BottomNavigationBar Design with App Theme Color ---
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedFontSize: 14,
                  unselectedFontSize: 13,
                  selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2, color: Colors.white),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Colors.black),
                  items: [
                    BottomNavigationBarItem(
                      icon: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: state.selectedIndex == 0 ? Theme.of(context).colorScheme.primary.withOpacity(0.25) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.dashboard,
                          size: state.selectedIndex == 0 ? 32 : 26,
                          color: state.selectedIndex == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: state.selectedIndex == 1 ? Theme.of(context).colorScheme.primary.withOpacity(0.25) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          size: state.selectedIndex == 1 ? 32 : 26,
                          color: state.selectedIndex == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                      label: 'Order',
                    ),
                    BottomNavigationBarItem(
                      icon: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: state.selectedIndex == 2 ? Theme.of(context).colorScheme.primary.withOpacity(0.25) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                            int cartCount = 0;
                            if (cartState is CartLoaded) {
                              cartCount = cartState.items.length;
                            }
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.add_shopping_cart,
                                  size: state.selectedIndex == 2 ? 32 : 26,
                                  color: state.selectedIndex == 2 ? Colors.white : Colors.black,
                                ),
                                if (cartCount > 0)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Text(
                                        '$cartCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      label: 'Cart',
                    ),
                    BottomNavigationBarItem(
                      icon: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: state.selectedIndex == 3 ? Theme.of(context).colorScheme.primary.withOpacity(0.25) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.account_circle,
                          size: state.selectedIndex == 3 ? 32 : 26,
                          color: state.selectedIndex == 3 ? Colors.white : Colors.black,
                        ),
                      ),
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
              ),
            ),
          );
        },
        ),
      ),
    );
  }
}
