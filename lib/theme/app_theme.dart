// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFFC107); // Amber-like yellow
  static const Color background = Color(0xFFF5F5F5); // Light grey background
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color iconColor = Color(0xFF424242);
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.iconColor),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.primary,
    ),
  );
}