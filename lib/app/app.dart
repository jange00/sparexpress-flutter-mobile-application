import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/app/theme/app_theme.dart';
import 'package:sparexpress/features/splash/presentation/view/splash_view.dart';
import 'package:sparexpress/features/splash/presentation/view_model/splash_view_model.dart';

class ThemeModeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleDark(bool isDark) {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}

class App extends StatelessWidget {
  final Widget Function(BuildContext, Widget?)? builder;
  const App({super.key, this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeNotifier(),
      child: Consumer<ThemeModeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp(
            title: 'Sparexpress',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getApplicationTheme(isDarkMode: false),
            darkTheme: AppTheme.getApplicationTheme(isDarkMode: true),
            themeMode: themeNotifier.themeMode,
            home: BlocProvider.value(
              value: serviceLocator<SplashViewModel>(),
              child: SplashView(),
            ),
            builder: builder,
          );
        },
      ),
    );
  }
}