// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import '../models/configuracion_model.dart';
import '../theme/app_colors.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  Configuracion? _configuracion;

  ThemeData get themeData => _themeData;
  Configuracion? get configuracion => _configuracion;

  void updateTheme(Configuracion config) {
    _configuracion = config;

    // Update AppColors
    AppColors.initialize(
      primary: _hexToColor(config.primario),
      secondary: _hexToColor(config.secundario),
      accent1: _hexToColor(config.acento1),
      accent2: _hexToColor(config.acento2),
    );

    _themeData = _buildThemeData();
    notifyListeners();
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: _hexToColor(_configuracion!.primario),
        secondary: _hexToColor(_configuracion!.secundario),
        primaryContainer: _hexToColor(_configuracion!.acento1),
        secondaryContainer: _hexToColor(_configuracion!.acento2),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onPrimaryContainer: Colors.black87,
        onSecondaryContainer: Colors.black87,
        surface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _hexToColor(_configuracion!.primario),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _hexToColor(_configuracion!.secundario),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _hexToColor(_configuracion!.primario),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _hexToColor(_configuracion!.primario).withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _hexToColor(_configuracion!.primario).withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _hexToColor(_configuracion!.primario),
            width: 2,
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
