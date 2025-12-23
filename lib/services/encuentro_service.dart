import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/encuentro_model.dart';
import '../config/environment.dart';

class EncuentroService {
  final String _baseUrl = '${Environment.baseUrl}/api/encuentros';
  final http.Client _client;

  EncuentroService({http.Client? client}) : _client = client ?? http.Client();

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

  // Get all encuentros
  Future<List<Encuentro>> getAllEncuentros() async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = EncuentroListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener los encuentros: $e');
    }
  }

  // Get encuentro by ID
  Future<Encuentro> getEncuentroById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = EncuentroResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener el encuentro: $e');
    }
  }

  // Create a new encuentro
  Future<Encuentro> createEncuentro(CreateEncuentroRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = EncuentroResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear el encuentro: $e');
    }
  }

  // Create multiple encuentros
  Future<List<Encuentro>> createMultipleEncuentros(
      CreateMultipleEncuentrosRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bulk'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = EncuentroListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear múltiples encuentros: $e');
    }
  }

  // Update an existing encuentro
  Future<Encuentro> updateEncuentro(
      int id, UpdateEncuentroRequest request) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = EncuentroResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al actualizar el encuentro: $e');
    }
  }

  // Delete an encuentro
  Future<void> deleteEncuentro(int id) async {
    try {
      await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Error al eliminar el encuentro: $e');
    }
  }

  // Get encuentros by subcategoria
  Future<EncuentroPageData> getEncuentrosBySubcategoria(
    int subcategoriaId, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/subcategoria/$subcategoriaId')
            .replace(queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        }),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = EncuentroPageResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener encuentros por subcategoría: $e');
    }
  }

  // Search encuentros by query parameters
  Future<EncuentroPageData> searchEncuentrosByQuery(
    EncuentroSearchParams params, {
    int page = 0,
    int size = 5,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
        if (params.titulo != null) 'titulo': params.titulo,
        if (params.fechaInicio != null) 'fechaInicio': params.fechaInicio,
        if (params.fechaFin != null) 'fechaFin': params.fechaFin,
        if (params.subcategoriaId != null)
          'subcategoriaId': params.subcategoriaId.toString(),
        if (params.equipoId != null) 'equipoId': params.equipoId.toString(),
        if (params.estadioId != null) 'estadioId': params.estadioId.toString(),
        if (params.serieId != null) 'serieId': params.serieId.toString(),
        if (params.estado != null) 'estado': params.estado,
      };

      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: queryParams,
      );
      
      final response = await _client.get(
        uri,
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = EncuentroPageResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      developer.log(
        'Error al buscar encuentros por consulta: $e',
        name: 'EncuentroService',
        error: e,
      );
      throw Exception('Error al buscar encuentros por consulta: $e');
    }
  }

  // Get encuentros by equipo
  Future<EncuentroPageData> getEncuentrosByEquipo(
    int equipoId, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/equipo/$equipoId').replace(queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        }),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = EncuentroPageResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener encuentros por equipo: $e');
    }
  }
}
