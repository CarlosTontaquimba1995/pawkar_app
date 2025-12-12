import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plantilla_model.dart';
import '../config/environment.dart';

class PlantillaService {
  final String _baseUrl = '${Environment.baseUrl}/api/plantillas';
  final http.Client _client;

  PlantillaService({http.Client? client}) : _client = client ?? http.Client();

  // Get headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  // Handle API errors
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw Exception('Solicitud incorrecta: ${response.body}');
      case 401:
        throw Exception('No autorizado: Por favor inicie sesión nuevamente');
      case 403:
        throw Exception(
          'Acceso denegado: No tiene permisos para realizar esta acción',
        );
      case 404:
        throw Exception('Recurso no encontrado');
      case 500:
        throw Exception('Error interno del servidor');
      default:
        throw Exception(
          'Error al procesar la solicitud: ${response.statusCode}',
        );
    }
  }

  /// Obtiene todas las plantillas registradas
  Future<List<Plantilla>> getAllPlantillas() async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = PlantillaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener plantillas: $e');
    }
  }

  /// Obtiene una plantilla específica por ID de equipo y jugador
  Future<Plantilla> getPlantillaById(int equipoId, int jugadorId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$equipoId/$jugadorId'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = PlantillaResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener la plantilla: $e');
    }
  }

  /// Obtiene todas las plantillas de un equipo específico
  Future<List<Plantilla>> getPlantillasByEquipo(int equipoId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/equipo/$equipoId'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = PlantillaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener plantillas del equipo: $e');
    }
  }

  /// Crea una nueva plantilla
  Future<Plantilla> createPlantilla(CreatePlantillaRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = PlantillaResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear la plantilla: $e');
    }
  }

  /// Crea múltiples plantillas en una sola petición
  Future<List<Plantilla>> createMultiplePlantillas(
      CreateMultiplePlantillasRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bulk'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = PlantillaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear múltiples plantillas: $e');
    }
  }

  /// Elimina una plantilla existente
  Future<DeletePlantillaResponse> deletePlantilla(
      int equipoId, int jugadorId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$equipoId/$jugadorId'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return DeletePlantillaResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al eliminar la plantilla: $e');
    }
  }

  /// Obtiene todas las plantillas de una subcategoría específica
  Future<List<Plantilla>> getPlantillasBySubcategoria(
      int subcategoriaId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/subcategoria/$subcategoriaId'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = PlantillaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener plantillas por subcategoría: $e');
    }
  }
}
