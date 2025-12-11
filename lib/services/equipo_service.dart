import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/equipo_model.dart';
import '../config/environment.dart';

class EquipoService {
  final String _baseUrl = '${Environment.baseUrl}/api/equipos';
  final http.Client _client = http.Client();

  // Private method to get headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Public headers without auth
  Future<Map<String, String>> _getPublicHeaders() async {
    return {'Content-Type': 'application/json'};
  }

  // Handle API response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      final error = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(error['message'] ?? 'Error: ${response.statusCode}');
    }
  }

  // Get paginated teams with search and sort options
  Future<EquipoListPageResponse> getEquipos({
    int page = 0,
    int size = 10,
    String? sort,
    String? nombre,
    String? search,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl').replace(
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          if (sort != null) 'sort': sort,
          if (nombre != null) 'nombre': nombre,
          if (search != null) 'search': search,
        },
      );
      
      final response = await _client.get(
        uri, headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return EquipoListPageResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener equipos: $e');
    }
  }

  // Get teams by serie
  Future<EquipoListResponse> getEquiposBySerie(int serieId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/serie/$serieId'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return EquipoListResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener equipos por serie: $e');
    }
  }

  // Get teams by subcategory
  Future<EquipoListResponse> getEquiposBySubcategoria(
    int subcategoriaId, {
    int? serieId,
    int? page,
    int? size,
    String? sort,
    String? nombre,
    String? search,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/subcategoria/$subcategoriaId').replace(
        queryParameters: {
          if (serieId != null) 'serieId': serieId.toString(),
          if (page != null) 'page': page.toString(),
          if (size != null) 'size': size.toString(),
          if (sort != null) 'sort': sort,
          if (nombre != null) 'nombre': nombre,
          if (search != null) 'search': search,
        },
      );
      
      final response = await _client.get(
        uri, headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return EquipoListResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener equipos por subcategoría: $e');
    }
  }

  // Get team by ID
  Future<Equipo> getEquipoById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return Equipo.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener el equipo: $e');
    }
  }

  // Create a new team
  Future<Equipo> createEquipo(CreateEquipoRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: jsonEncode(request.toJson()),
      );
      final data = _handleResponse(response);
      return Equipo.fromJson(data);
    } catch (e) {
      throw Exception('Error al crear el equipo: $e');
    }
  }

  // Create multiple teams
  Future<EquipoListResponse> createEquiposBulk(
    CreateMultipleEquiposRequest request,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bulk'),
        headers: await _getHeaders(),
        body: jsonEncode(request.toJson()),
      );
      final data = _handleResponse(response);
      return EquipoListResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al crear equipos: $e');
    }
  }

  // Update a team
  Future<Equipo> updateEquipo(int id, UpdateEquipoRequest request) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
        body: jsonEncode(request.toJson()),
      );
      final data = _handleResponse(response);
      return Equipo.fromJson(data);
    } catch (e) {
      throw Exception('Error al actualizar el equipo: $e');
    }
  }

  // Delete a team
  Future<Map<String, dynamic>> deleteEquipo(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error al eliminar el equipo: $e');
    }
  }

  // Check if teams exist
  Future<bool> checkEquiposExist() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/existen'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response) as bool;
    } catch (e) {
      throw Exception('Error al verificar equipos: $e');
    }
  }

  // Get teams count
  Future<EquipoCountResponse> getEquiposCount() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/count'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return EquipoCountResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener el conteo de equipos: $e');
    }
  }
}
