import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/serie_model.dart';
import '../config/environment.dart';

class SerieService {
  final String _baseUrl = '${Environment.baseUrl}/api/series';
  final http.Client _client;

  SerieService({http.Client? client}) : _client = client ?? http.Client();

  // Get headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  // Get public headers (no auth required)
  Map<String, String> _getPublicHeaders() {
    return {'Content-Type': 'application/json'};
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

  // Get all series by subcategoria
  Future<List<Serie>> getSeriesBySubcategoria(int subcategoriaId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/subcategoria/$subcategoriaId'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = SerieListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener series por subcategoría: $e');
    }
  }

  // Get serie by ID
  Future<Serie> getSerieById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = SerieResponse.fromJson(data);
      if (responseObj.data == null) throw Exception('Serie no encontrada');
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al obtener la serie: $e');
    }
  }

  // Create a new serie
  Future<Serie> createSerie(CreateSerieRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = SerieResponse.fromJson(data);
      if (responseObj.data == null) {
        throw Exception('Error al crear la serie');
      }
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al crear la serie: $e');
    }
  }

  // Create multiple series
  Future<List<Serie>> createMultipleSeries(
    CreateMultipleSeriesRequest request,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bulk'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = SerieListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear series: $e');
    }
  }

  // Update a serie
  Future<Serie> updateSerie(int id, UpdateSerieRequest request) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = SerieResponse.fromJson(data);
      if (responseObj.data == null) {
        throw Exception('Error al actualizar la serie');
      }
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al actualizar la serie: $e');
    }
  }

  // Delete a serie
  Future<DeleteSerieResponse> deleteSerie(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return DeleteSerieResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al eliminar la serie: $e');
    }
  }

  // Check if series exist for subcategoria
  Future<bool> checkSeriesExist(int subcategoriaId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/subcategoria/$subcategoriaId/existen'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return data['exists'] ?? false;
    } catch (e) {
      print('Error al verificar existencia de series: $e');
      return false;
    }
  }
}
