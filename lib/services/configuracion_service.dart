import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/configuracion_model.dart';
import '../config/environment.dart';

class ConfiguracionService {
  final String _baseUrl = '${Environment.baseUrl}/api/configuracion';
  final http.Client _client;

  ConfiguracionService({http.Client? client})
    : _client = client ?? http.Client();

  // Headers for authenticated requests
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  // Headers for public requests (no auth required)
  Map<String, String> _getPublicHeaders() {
    return {'Content-Type': 'application/json'};
  }

  // Manejo de errores
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw _handleError(response);
    }
  }

  Exception _handleError(http.Response response) {
    switch (response.statusCode) {
      case 401:
        return Exception('No autorizado: Por favor inicie sesión nuevamente');
      case 403:
        return Exception(
          'Acceso denegado: No tiene permisos para realizar esta acción',
        );
      case 404:
        return Exception('Recurso no encontrado');
      case 500:
        return Exception('Error del servidor: Intente nuevamente más tarde');
      default:
        return Exception('Error en la petición: ${response.statusCode}');
    }
  }

  // Obtener configuración activa
  Future<ConfiguracionResponse> getConfiguracion() async {
    try {
      final url = _baseUrl; // Store the URL for logging
      final response = await _client
          .get(Uri.parse(url), headers: _getPublicHeaders())
          .timeout(const Duration(seconds: 10));
      debugPrint('Response: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = _handleResponse(response);
        return ConfiguracionResponse.fromJson(jsonResponse);
      } else {
        throw HttpException('Error del servidor: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw Exception(
        'No se pudo conectar al servidor. Verifica tu conexión a internet.',
      );
    } on TimeoutException catch (_) {
      throw Exception(
        'La conexión está tardando demasiado. Verifica que el servidor esté en ejecución.',
      );
    } on FormatException catch (_) {
      throw Exception('Error en el formato de la respuesta del servidor.');
    } on HttpException catch (_) {
      rethrow;
    } catch (_) {
      throw Exception('Error al obtener la configuración');
    }
  }


  // Actualizar configuración
  Future<ConfiguracionResponse> updateConfiguracion(
    UpdateConfiguracionRequest configuracion,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: jsonEncode(configuracion.toJson()),
      );

      final jsonResponse = _handleResponse(response);
      return ConfiguracionResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Error al actualizar la configuración: $e');
    }
  }
}
