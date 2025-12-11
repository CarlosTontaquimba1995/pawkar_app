import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/equipo_model.dart';
import '../config/environment.dart';

class EquipoService {
  final String _baseUrl = '${Environment.baseUrl}/equipos';
  final http.Client _client = http.Client();

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> _getPublicHeaders() async {
    return {'Content-Type': 'application/json'};
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Get paginated teams with search and sort options
  Future<EquipoListPageResponse> getEquipos({
    int page = 0,
    int size = 5,
    String? sort,
    String? nombre,
    String? search,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse(
          '$_baseUrl?'
          'page=$page'
          '&size=$size'
          '${sort != null ? '&sort=$sort' : ''}'
          '${nombre != null ? '&nombre=$nombre' : ''}'
          '${search != null ? '&search=$search' : ''}',
        ),
        headers: await _getPublicHeaders(),
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
        headers: await _getPublicHeaders(),
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
      final params = EquipoBySubcategoryParams(
        serieId: serieId,
        page: page,
        size: size,
        sort: sort,
        nombre: nombre,
        search: search,
      ).toJson();

      final queryString = Uri(queryParameters: params).query;
      final response = await _client.get(
        Uri.parse('$_baseUrl/subcategoria/$subcategoriaId?$queryString'),
        headers: await _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      return EquipoListResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener equipos por subcategoría: $e');
    }
  }

  // Get team by ID
  Future<EquipoResponse> getEquipoById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      return EquipoResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener el equipo: $e');
    }
  }

  // Create a new team
  Future<EquipoResponse> createEquipo(CreateEquipoRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      return EquipoResponse.fromJson(data);
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
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      return EquipoListResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al crear equipos: $e');
    }
  }

  // Update a team
  Future<EquipoResponse> updateEquipo(
    int id,
    UpdateEquipoRequest request,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      return EquipoResponse.fromJson(data);
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

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error al eliminar el equipo: $e');
    }
  }

  // Check if teams exist
  Future<bool> checkEquiposExist() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/existen'),
        headers: await _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      return data as bool;
    } catch (e) {
      throw Exception('Error al verificar existencia de equipos: $e');
    }
  }

  // Get teams count
  Future<EquipoCountResponse> getEquiposCount() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/count'),
        headers: await _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      return EquipoCountResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener el conteo de equipos: $e');
    }
  }
}
