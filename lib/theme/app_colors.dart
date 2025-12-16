import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF473587);
  static const Color lightPrimaryVariant = Color(0xFF1E1B4B);
  static const Color lightSecondary = Color(0xFFA81B7C);
  static const Color lightSecondaryVariant = Color(0xFF7A145C);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F9FA);
  static const Color lightError = Color(0xFFB00020);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1A1A1A);
  static const Color lightOnSurface = Color(0xFF1A1A1A);
  static const Color lightOnSurfaceVariant = Color(0xFF49454F);
  static const Color lightOnError = Color(0xFFFFFFFF);

  // Dark Theme Colors - Enhanced contrast
  static const Color darkPrimary = Color(
    0xFF9C64FF,
  ); // Brighter purple for better visibility
  static const Color darkPrimaryVariant = Color(
    0xFF7C4DFF,
  ); // More saturated purple
  static const Color darkSecondary = Color(0xFF00E5FF); // Brighter teal
  static const Color darkSecondaryVariant = Color(
    0xFF00B8D4,
  ); // More saturated teal
  static const Color darkBackground = Color(0xFF121212); // Keep dark background
  static const Color darkSurface = Color(
    0xFF1E1E1E,
  ); // Slightly lighter than background
  static const Color darkError = Color(0xFFFF5252); // Brighter red for errors
  static const Color darkOnPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color darkOnSecondary = Color(
    0xFF000000,
  ); // Black text on secondary
  static const Color darkOnBackground = Color(0xFFFFFFFF); // White text
  static const Color darkOnSurface = Color(0xFFFFFFFF); // White text on surface
  static const Color darkOnError = Color(0xFFFFFFFF); // White text on error

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  static const Color error = Color(0xFFF44336);

  // Neutral Colors - Enhanced contrast
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
  static const Color grey = Color(
    0xFFB0B0B0,
  ); // Lighter grey for better visibility
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(
    0xFF616161,
  ); // Lighter dark grey for better contrast

  // Text Colors - Enhanced contrast
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(
    0xFF757575,
  ); // Lighter for better contrast
  static const Color textHint = Color(0xFF9E9E9E);
  
  // Dark Theme Text Colors
  static const Color darkTextPrimary = Color(
    0xFFFFFFFF,
  ); // White for primary text
  static const Color darkTextSecondary = Color(
    0xFFE0E0E0,
  ); // Light grey for secondary text
  static const Color darkTextHint = Color(0xFFB0B0B0); // Lighter grey for hints
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Initialize colors for runtime theming
  static late Color primary;
  static late Color primaryVariant;
  static late Color secondary;
  static late Color secondaryVariant;
  static late Color background;
  static late Color surface;
  static late Color errorColor;
  static late Color onPrimary;
  static late Color onSecondary;
  static late Color onBackground;
  static late Color onSurface;
  static late Color onError;

  // Initialize colors with light or dark theme
  static void initialize({bool isDark = false}) {
    if (isDark) {
      primary = darkPrimary;
      primaryVariant = darkPrimaryVariant;
      secondary = darkSecondary;
      secondaryVariant = darkSecondaryVariant;
      background = darkBackground;
      surface = darkSurface;
      errorColor = darkError;
      onPrimary = darkOnPrimary;
      onSecondary = darkOnSecondary;
      onBackground = darkOnBackground;
      onSurface = darkOnSurface;
      onError = darkOnError;
    } else {
      primary = lightPrimary;
      primaryVariant = lightPrimaryVariant;
      secondary = lightSecondary;
      secondaryVariant = lightSecondaryVariant;
      background = lightBackground;
      surface = lightSurface;
      errorColor = lightError;
      onPrimary = lightOnPrimary;
      onSecondary = lightOnSecondary;
      onBackground = lightOnBackground;
      onSurface = lightOnSurface;
      onError = lightOnError;
    }
  }
  
  /// Update theme colors dynamically
  static void updateColors({
    Color? primaryColor,
    Color? primaryVariantColor,
    Color? secondaryColor,
    Color? secondaryVariantColor,
    bool isDark = false,
  }) {
    if (isDark) {
      primary = primaryColor ?? darkPrimary;
      primaryVariant = primaryVariantColor ?? darkPrimaryVariant;
      secondary = secondaryColor ?? darkSecondary;
      secondaryVariant = secondaryVariantColor ?? darkSecondaryVariant;
    } else {
      primary = primaryColor ?? lightPrimary;
      primaryVariant = primaryVariantColor ?? lightPrimaryVariant;
      secondary = secondaryColor ?? lightSecondary;
      secondaryVariant = secondaryVariantColor ?? lightSecondaryVariant;
    }
  }
}

// Initialize colors when the app starts
void initAppColors() {
  AppColors.initialize();
}
