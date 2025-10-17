import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2E7D32); // Green 800
  static const Color primaryLight = Color(0xFF60AD5E); // Green 600
  static const Color primaryDark = Color(0xFF005005); // Green 900
  
  // Secondary Colors
  static const Color secondary = Color(0xFFF57F17); // Amber 800
  static const Color secondaryLight = Color(0xFFFFB04C); // Amber 600
  
  // Status Colors
  static const Color success = Color(0xFF388E3C); // Green 700
  static const Color warning = Color(0xFFFFA000); // Amber 700
  static const Color error = Color(0xFFD32F2F); // Red 700
  static const Color info = Color(0xFF1976D2); // Blue 700
  
  // Grayscale
  static const Color black = Color(0xFF212121);
  static const Color darkGrey = Color(0xFF424242);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color background = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFF9E9E9E);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  
  // Transparent
  static const Color transparent = Color(0x00000000);
  
  // Social Colors
  static const Color facebook = Color(0xFF3B5998);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color instagram = Color(0xFFE4405F);
  static const Color youtube = Color(0xFFCD201F);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
