import 'package:flutter/material.dart';
import 'package:sparexpress/app/constant/theme_constant.dart';

class AppTheme {
  AppTheme._();

  static ThemeData getApplicationTheme({required bool isDarkMode}) {
    final darkBg = const Color(0xFF181A20);
    final darkSurface = const Color(0xFF23262F);
    final darkCard = const Color(0xFF23262F);
    final darkBorder = Colors.white10;
    final darkPrimary = ThemeConstant.darkPrimaryColor;
    final darkOnPrimary = Colors.white;
    final darkOnSurface = Colors.white70;
    final darkOnBackground = Colors.white;

    return ThemeData(
      colorScheme: isDarkMode
          ? ColorScheme(
              brightness: Brightness.dark,
              primary: darkPrimary,
              onPrimary: darkOnPrimary,
              secondary: Colors.tealAccent,
              onSecondary: Colors.black,
              error: Colors.redAccent,
              onError: Colors.white,
              background: darkBg,
              onBackground: darkOnBackground,
              surface: darkSurface,
              onSurface: darkOnSurface,
            )
          : const ColorScheme.light(
              primary: ThemeConstant.primaryColor,
              background: Colors.white,
              surface: Colors.white,
              onPrimary: Colors.black,
              onBackground: Colors.black,
              onSurface: Colors.black87,
              secondary: Colors.teal,
              onSecondary: Colors.white,
              error: Colors.red,
              onError: Colors.white,
            ),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      fontFamily: 'Montserrat',
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 1.5,
        backgroundColor: isDarkMode ? darkSurface : ThemeConstant.appBarColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      scaffoldBackgroundColor: isDarkMode ? darkBg : Colors.white,
      cardColor: isDarkMode ? darkCard : Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: isDarkMode ? darkOnPrimary : Colors.white,
          backgroundColor: isDarkMode ? darkPrimary : ThemeConstant.primaryColor,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDarkMode ? darkPrimary : ThemeConstant.primaryColor,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDarkMode ? darkPrimary : ThemeConstant.primaryColor,
          side: BorderSide(color: isDarkMode ? darkPrimary : ThemeConstant.primaryColor, width: 1.5),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(15),
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 20, color: isDarkMode ? Colors.white70 : Colors.black),
        hintStyle: TextStyle(color: isDarkMode ? Colors.white38 : Colors.black45),
        fillColor: isDarkMode ? darkSurface : Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? darkBorder : Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? darkPrimary : ThemeConstant.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isDarkMode ? darkPrimary : ThemeConstant.primaryColor,
        linearTrackColor: isDarkMode ? Colors.white12 : Colors.black12,
      ),
      cardTheme: CardThemeData(
        color: isDarkMode ? darkCard : Colors.white,
        shadowColor: isDarkMode ? Colors.black54 : Colors.grey[200],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDarkMode ? BorderSide(color: darkBorder, width: 1) : BorderSide.none,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkMode ? darkSurface : ThemeConstant.primaryColor,
        selectedItemColor: isDarkMode ? darkPrimary : Colors.white,
        unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black,
        type: BottomNavigationBarType.fixed,
        elevation: 1.5,
      ),
      textTheme: isDarkMode
          ? const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(color: Colors.white60),
              titleLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white70),
              titleSmall: TextStyle(color: Colors.white60),
              labelLarge: TextStyle(color: Colors.white),
              labelMedium: TextStyle(color: Colors.white70),
              labelSmall: TextStyle(color: Colors.white60),
            )
          : null,
      iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      dividerColor: isDarkMode ? Colors.white12 : Colors.grey[300],
      listTileTheme: ListTileThemeData(
        tileColor: isDarkMode ? darkSurface : Colors.white,
        iconColor: isDarkMode ? Colors.white : Colors.black,
        textColor: isDarkMode ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
