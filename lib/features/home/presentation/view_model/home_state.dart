import 'package:flutter/widgets.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/account_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/dashboard_view.dart';

class HomeState{
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({ required this.selectedIndex, required this.views});

  // Initial State
  static HomeState initial() {
    return HomeState(
      selectedIndex: 0, 
      views: [
        DashboardView(),
        // BlocProvider.value(),
        AccountView(),
      ],
      );
  }

  HomeState copyWith({int? selectedIndex, List<Widget>? views}) {
    return HomeState(
      selectedIndex: selectedIndex  ?? this.selectedIndex, 
    views: views ?? this.views
    );
  }
}