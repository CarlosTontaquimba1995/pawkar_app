import 'package:flutter/material.dart';
import 'package:pawkar_app/services/configuracion_service.dart';
import 'package:pawkar_app/theme/app_colors.dart';
import 'package:pawkar_app/theme/app_theme.dart';

class AppConfig {
  static Future<ThemeData> loadTheme() async {
    try {
      final configService = ConfiguracionService();
      final config = await configService.getConfiguracion();

      // Actualizar los colores con los de la base de datos
      AppColors.initialize(
        primary: Color(int.parse('0xFF${config.data.primario}')),
        secondary: Color(int.parse('0xFF${config.data.secundario}')),
        accent1: Color(int.parse('0xFF${config.data.acento1}')),
        accent2: Color(int.parse('0xFF${config.data.acento2}')),
      );

      return AppTheme.lightTheme;
    } catch (e) {
      print('Error cargando configuración: $e');
      // Usar tema por defecto si hay error
      return AppTheme.lightTheme;
    }
  }
}
