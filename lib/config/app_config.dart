import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pawkar_app/models/configuracion_model.dart';
import 'package:pawkar_app/services/configuracion_service.dart';
import 'package:pawkar_app/theme/app_colors.dart';
import 'package:pawkar_app/theme/app_theme.dart';

class AppConfig {
  // Default colors for offline mode
  static const String defaultPrimary = '#331D58'; // Primary color
  static const String defaultSecondary = '#482E76'; // Secondary color
  static const String defaultAccent1 = '#E00099'; // Accent 1
  static const String defaultAccent2 = '#F5C000'; // Accent 2

  static Color get defaultPrimaryColor => _parseColor(defaultPrimary);
  static Color get defaultSecondaryColor => _parseColor(defaultSecondary);
  static Color get defaultAccent1Color => _parseColor(defaultAccent1);
  static Color get defaultAccent2Color => _parseColor(defaultAccent2);

  static Configuracion get defaultConfig => Configuracion(
    configuracionId: 0,
    primario: defaultPrimary,
    secundario: defaultSecondary,
    acento1: defaultAccent1,
    acento2: defaultAccent2,
  );


  static final ConfiguracionService _configService = ConfiguracionService();
  static Configuracion? _cachedConfig;
  static DateTime? _lastFetched;
  static const Duration _cacheDuration = Duration(minutes: 30);

  // Private constructor to prevent instantiation
  AppConfig._();

  /// Gets the current configuration, either from cache or API
  static Future<Configuracion> getConfig() async {
    final now = DateTime.now();

    // Return cached config if it's still valid
    if (_cachedConfig != null &&
        _lastFetched != null &&
        now.difference(_lastFetched!) < _cacheDuration) {
      return _cachedConfig!;
    }

    try {
      final response = await _configService.getConfiguracion();
      if (response.success) {
        _cachedConfig = response.data;
        _lastFetched = now;
        return _cachedConfig!;
      }
      throw Exception('Failed to load configuration');
    } catch (e) {
      debugPrint('Error loading configuration: $e');
      if (_cachedConfig != null) {
        return _cachedConfig!;
      }
      rethrow;
    }
  }

  /// Loads and applies theme configuration
  static Future<ThemeData> loadTheme() async {
    try {
      Configuracion config;
      try {
        config = await getConfig();
      } catch (e) {
        debugPrint('Using default color scheme due to: $e');
        config = defaultConfig;
      }

      // Parse colors from config
      final primaryColor = _parseColor(config.primario);
      final secondaryColor = _parseColor(config.secundario);
      final accent1 = _parseColor(config.acento1);
      final accent2 = _parseColor(config.acento2);

      // Update AppColors with the new colors
      AppColors.updateColors(
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        primaryVariantColor: accent1,
        secondaryVariantColor: accent2,
        isDark: false, // or determine based on theme mode
      );

      return AppTheme.lightTheme;
    } catch (e) {
      debugPrint('Error applying theme configuration: $e');
      // Apply default colors as fallback
      AppColors.updateColors(
        primaryColor: defaultPrimaryColor,
        secondaryColor: defaultSecondaryColor,
        primaryVariantColor: defaultAccent1Color,
        secondaryVariantColor: defaultAccent2Color,
        isDark: false,
      );
      return AppTheme.lightTheme;
    }
  }

  /// Helper method to parse color from hex string
  static Color _parseColor(String hexColor) {
    try {
      // Ensure the color string is properly formatted
      String formattedColor = hexColor.trim();
      if (!formattedColor.startsWith('#')) {
        formattedColor = '#$formattedColor';
      }

      // Handle 3-digit hex codes
      if (formattedColor.length == 4) {
        final r = formattedColor[1];
        final g = formattedColor[2];
        final b = formattedColor[3];
        formattedColor = '#$r$r$g$g$b$b';
      }

      // Parse the color
      return Color(
        int.parse(
          formattedColor.replaceFirst('#', ''), radix: 16) + 0xFF000000,
      );
    } catch (e) {
      debugPrint('Error parsing color "$hexColor": $e');
      return Colors.blue; // Fallback color
    }
  }

  /// Force refresh the configuration
  static Future<void> refreshConfig() async {
    _lastFetched = null;
    await getConfig();
  }
}
