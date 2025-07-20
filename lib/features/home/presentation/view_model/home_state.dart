import 'package:flutter/widgets.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/account_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/dashboard_view.dart';

class HomeState {
  final int selectedIndex;
  final String fullname;

  const HomeState({
    required this.selectedIndex,
    required this.fullname,
  });

  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      fullname: "Guest",
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    String? fullname,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      fullname: fullname ?? this.fullname,
    );
  }
}