import 'package:flutter/material.dart';

class AppColors {
  static const Color brandYellow = Color(0xFFFFD700);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color gray = Color(0xFFEEEEEE);
  static const Color darkGray = Color(0xFF444444);
}

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.brandYellow,
  scaffoldBackgroundColor: AppColors.white,
  colorScheme: ColorScheme.light(
    primary: AppColors.brandYellow,
    secondary: AppColors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.brandYellow,
    foregroundColor: AppColors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.brandYellow,
      foregroundColor: AppColors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.gray,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: AppColors.darkGray),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: AppColors.darkGray),
    titleLarge: TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
  ),
);
