import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_state.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class MockLoginViewModel extends Mock implements LoginViewModel {}

void main() {
  late HomeViewModel homeViewModel;
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    homeViewModel = HomeViewModel(loginViewModel: mockLoginViewModel);
  });

  group('HomeViewModel', () {
    test('should initialize with default state', () {
      expect(homeViewModel.state.selectedIndex, 0);
      expect(homeViewModel.state.fullname, 'Guest');
    });

    test('should update selected index when onTapped is called', () {
      const newIndex = 2;
      homeViewModel.onTapped(newIndex);
      expect(homeViewModel.state.selectedIndex, newIndex);
    });

    test('should update fullname when setUserName is called', () {
      const newName = 'John Doe';
      homeViewModel.setUserName(newName);
      expect(homeViewModel.state.fullname, newName);
    });

    test('should handle multiple onTapped calls', () {
      homeViewModel.onTapped(1);
      homeViewModel.onTapped(3);
      homeViewModel.onTapped(2);
      expect(homeViewModel.state.selectedIndex, 2);
    });

    test('should handle multiple setUserName calls', () {
      homeViewModel.setUserName('John');
      homeViewModel.setUserName('Jane');
      homeViewModel.setUserName('Bob');
      expect(homeViewModel.state.fullname, 'Bob');
    });

    test('should maintain other state properties when updating selectedIndex', () {
      const initialName = 'Test User';
      homeViewModel.setUserName(initialName);
      homeViewModel.onTapped(1);
      expect(homeViewModel.state.selectedIndex, 1);
      expect(homeViewModel.state.fullname, initialName);
    });

    test('should maintain other state properties when updating fullname', () {
      const initialIndex = 2;
      homeViewModel.onTapped(initialIndex);
      homeViewModel.setUserName('New User');
      expect(homeViewModel.state.selectedIndex, initialIndex);
      expect(homeViewModel.state.fullname, 'New User');
    });

    test('should handle negative index in onTapped', () {
      homeViewModel.onTapped(-1);
      expect(homeViewModel.state.selectedIndex, -1);
    });

    test('should handle empty string in setUserName', () {
      homeViewModel.setUserName('');
      expect(homeViewModel.state.fullname, '');
    });

    test('should handle special characters in setUserName', () {
      homeViewModel.setUserName('User with émojis 🚀');
      expect(homeViewModel.state.fullname, 'User with émojis 🚀');
    });

    test('should handle long name in setUserName', () {
      const longName = 'This is a very long user name that might exceed normal limits';
      homeViewModel.setUserName(longName);
      expect(homeViewModel.state.fullname, longName);
    });
  });
} 