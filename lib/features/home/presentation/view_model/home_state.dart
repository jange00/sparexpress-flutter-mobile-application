import 'package:flutter/widgets.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/account_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/dashboard_view.dart';

class HomeState {
  final int selectedIndex;
  final List<Widget> views;
  final String fullname;

  const HomeState({
    required this.selectedIndex,
    required this.views,
    required this.fullname,
  });

  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        const DashboardView(),
        const Center(child: Text('Order Page')),
        const Center(child: Text('Cart Page')),
        const AccountView(),
      ],
      fullname: "Guest",
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
    String? fullname,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
      fullname: fullname ?? this.fullname,
    );
  }
}