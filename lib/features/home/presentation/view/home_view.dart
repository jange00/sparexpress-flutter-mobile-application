import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/searchBar/search_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final fullname = state.fullname;

        // Select which widget to show based on selectedIndex
        Widget bodyWidget;
        switch (state.selectedIndex) {
          case 0:
            bodyWidget = const DashboardView();
            break;
          case 1:
            bodyWidget = const Center(child: Text('Order Page'));
            break;
          case 2:
            bodyWidget = const Center(child: Text('Cart Page'));
            break;
          case 3:
            bodyWidget = const Center(child: Text('Account Page'));
            break;
          default:
            bodyWidget = const DashboardView();
        }

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6F00), Color(0xFFC107)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            fullname,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/images/mouse.jpg'),
                      backgroundColor: Colors.white24,
                    ),
                  ],
                ),
              ),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Search bar moved here
                SearchBarWidget(
                  controller: searchController,
                  onSearch: (query) {
                    print('Searching: $query');
                  },
                ),
                const SizedBox(height: 12),

                // Flexible body content
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
