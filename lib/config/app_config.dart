import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pawkar_app/models/configuracion_model.dart';
import 'package:pawkar_app/services/configuracion_service.dart';
import 'package:pawkar_app/theme/app_colors.dart';
import 'package:pawkar_app/theme/app_theme.dart';

class AppConfig {
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
      final config = await getConfig();

      // Update theme colors from config
      final colorMap = {
        'primario': config.primario,
        'secundario': config.secundario,
        'acento1': config.acento1,
        'acento2': config.acento2,
      };
      
      // Update AppColors
      AppColors.initialize(
        primary: _parseColor(config.primario),
        secondary: _parseColor(config.secundario),
        accent1: _parseColor(config.acento1),
        accent2: _parseColor(config.acento2),
      );
      
      // Update AppTheme
      AppTheme.updateColors(colorMap);

      return AppTheme.light();
    } catch (e) {
      debugPrint('Error loading theme configuration: $e');
      return AppTheme.light(); // Fallback to default theme
    }
  }

  /// Helper method to parse color from hex string
  static Color _parseColor(String hexColor) {
    try {
      return Color(
        int.parse(
          hexColor.startsWith('#')
              ? '0xFF${hexColor.substring(1)}'
              : '0xFF$hexColor',
        ),
      );
    } catch (e) {
      debugPrint('Error parsing color $hexColor: $e');
      return Colors.blue; // Fallback color
    }
  }

  /// Force refresh the configuration
  static Future<void> refreshConfig() async {
    _lastFetched = null;
    await getConfig();
  }
}
