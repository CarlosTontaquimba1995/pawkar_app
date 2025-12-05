import 'package:flutter/material.dart';

/// AppTheme - modern minimal theme with dynamic theming support
class AppTheme {
  // Default colors (will be overridden by config)
  static Color _primary = const Color(0xFF473587);
  static Color _primaryContainer = const Color(0xFFEEF2FF);
  static Color _secondary = const Color(0xFFA81B7C);
  static Color _secondaryContainer = const Color(0xFFFFE8F5);
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _surfaceDark = Color(0xFF121417);
  static const String _fontFamily = 'Inter';
  
  // Update theme colors from configuration
  static void updateColors(Map<String, dynamic> config) {
    _primary = _hexToColor(config['primario'] ?? '#473587');
    _primaryContainer = _primary.withAlpha(26); // ~10% opacity
    _secondary = _hexToColor(config['secundario'] ?? '#A81B7C');
    _secondaryContainer = _secondary.withAlpha(26); // ~10% opacity
  }

  // Helper method to convert hex string to Color
  static Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static final TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
      fontFamily: _fontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
      fontFamily: _fontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.2,
      fontFamily: _fontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
    ),
    labelLarge: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
    ),
  );

  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _primary,
      onPrimary: Colors.white,
      primaryContainer: _primaryContainer,
      onPrimaryContainer: _primary,
      secondary: _secondary,
      onSecondary: Colors.white,
      secondaryContainer: _secondaryContainer,
      onSecondaryContainer: _secondary,
      surface: _surfaceLight,
      onSurface: const Color(0xFF0F1720),
      error: const Color(0xFFB00020),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        surfaceTintColor: Colors.transparent,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),

      // Buttons — action buttons use secondary, outlined/text use primary
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          side: BorderSide(color: colorScheme.secondary.withAlpha(79)),
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          padding: const EdgeInsets.all(12),
        ),
      ),

      // Cards with soft elevation and optional translucency
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 6,
        shadowColor: Colors.black.withAlpha(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      ),

      // Subtle motion defaults
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.onSurface.withAlpha(20),
        thickness: 1,
      ),
    );
  }

  // Backwards-compatible getters used by existing code
  static ThemeData get lightTheme => light();

  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _primary,
      onPrimary: Colors.white,
      primaryContainer: _primary.withAlpha(36),
      onPrimaryContainer: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.white,
      secondaryContainer: _secondary.withAlpha(31),
      onSecondaryContainer: _secondary,
      surface: _surfaceDark,
      onSurface: const Color(0xFFE6EEF4),
      error: const Color(0xFFCF6679),
      onError: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      textTheme: _textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          side: BorderSide(color: colorScheme.secondary.withAlpha(79)),
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          padding: const EdgeInsets.all(12),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 6,
        shadowColor: Colors.black.withAlpha(153),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        hintStyle: TextStyle(color: colorScheme.onSurface.withAlpha(179)),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.onSurface.withAlpha(20),
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme => dark();
}
