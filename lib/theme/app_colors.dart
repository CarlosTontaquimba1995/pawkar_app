import 'package:flutter/material.dart';

class AppColors {
  // Default colors
  static late Color primary;
  static late Color secondary;
  static late Color accent1;
  static late Color accent2;
  static late Color background;
  static late Color surface;
  static late Color error;
  static late Color onPrimary;
  static late Color onSecondary;
  static late Color onSurface;
  static late Color onError;
  static const Color teal = Color(0xFF83BDBC);

  // Initialize colors with default or provided values
  static void initialize({
    Color? primary,
    Color? secondary,
    Color? accent1,
    Color? accent2,
  }) {
    AppColors.primary = primary ?? const Color(0xFF473587);
    AppColors.secondary = secondary ?? const Color(0xFFA81B7C);
    AppColors.accent1 = accent1 ?? const Color(0xFFDA8764);
    AppColors.accent2 = accent2 ?? const Color(0xFF86BEBD);

    // Set derived colors
    background = Colors.white;
    surface = Colors.white;
    error = Colors.red;
    onPrimary = Colors.white;
    onSecondary = Colors.white;
    onSurface = Colors.black87;
    onError = Colors.white;
  }

  // Light theme colors
  static const Color lightPrimary = Color(0xFF473587);
  static const Color lightSecondary = Color(0xFFA81B7C);
  static const Color lightAccent1 = Color(0xFFDA8764);
  static const Color lightAccent2 = Color(0xFF86BEBD);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFB00020);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFFBB86FC);
  static const Color darkSecondary = Color(0xFF03DAC6);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkError = Color(0xFFCF6679);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Transparent
  static const Color transparent = Color(0x00000000);

  // Initialize with default values
  static void init() {
    initialize();
  }
}

// Initialize colors when the app starts
void initAppColors() {
  AppColors.initialize();
}
