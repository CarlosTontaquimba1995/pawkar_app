// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import '../models/configuracion_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  // Light & dark theme support
  ThemeData _lightTheme = AppTheme.lightTheme;
  ThemeData _darkTheme = AppTheme.darkTheme;

  // Manual theme override (null = follow system)
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;

  Configuracion? _configuracion;

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;
  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  Configuracion? get configuracion => _configuracion;

  /// Set theme mode: system, light, or dark
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    // Update isDarkMode based on the mode selected
    if (mode == ThemeMode.light) {
      _isDarkMode = false;
    } else if (mode == ThemeMode.dark) {
      _isDarkMode = true;
    } else {
      // System mode: detect from device settings
      // This will be updated in didChangeDependencies
    }
    notifyListeners();
  }

  /// Toggle between light and dark theme (manual override)
  void toggleTheme() {
    _themeMode = ThemeMode.light;
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  /// Update from system brightness (called when MediaQuery.platformBrightnessOf changes)
  void updateFromSystemBrightness(Brightness brightness) {
    if (_themeMode == ThemeMode.system) {
      _isDarkMode = brightness == Brightness.dark;
      notifyListeners();
    }
  }

  void updateTheme(Configuracion config) {
    _configuracion = config;

    // Update AppColors
    AppColors.updateColors(
      primaryColor: _hexToColor(config.primario),
      secondaryColor: _hexToColor(config.secundario),
      primaryVariantColor: _hexToColor(config.acento1),
      secondaryVariantColor: _hexToColor(config.acento2),
      isDark: _isDarkMode,
    );

    // For now, use AppTheme's built-in light/dark themes
    // (Optional: could create custom themes from config here)
    _lightTheme = AppTheme.lightTheme;
    _darkTheme = AppTheme.darkTheme;
    notifyListeners();
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
