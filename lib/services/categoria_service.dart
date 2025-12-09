import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/categoria_model.dart';
import '../config/environment.dart';

class CategoriaService {
  final String _baseUrl = '${Environment.baseUrl}/api/categorias';
  final http.Client _client;

  CategoriaService({http.Client? client}) : _client = client ?? http.Client();

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

  // Get all categories
  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = CategoriaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener categorías: $e');
    }
  }

  // Get category by ID
  Future<Categoria> getCategoriaById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = CategoriaResponse.fromJson(data);
      if (responseObj.data == null) throw Exception('Categoría no encontrada');
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al obtener la categoría: $e');
    }
  }

  // Create a new category
  Future<Categoria> createCategoria(CreateCategoriaRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = CategoriaResponse.fromJson(data);
      if (responseObj.data == null) {
        throw Exception('Error al crear la categoría');
      }
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al crear la categoría: $e');
    }
  }

  // Create multiple categories
  Future<List<Categoria>> createCategoriasBulk(
    CreateMultipleCategoriasRequest request,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bulk'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = CategoriaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear categorías: $e');
    }
  }

  // Update a category
  Future<Categoria> updateCategoria(
    int id,
    UpdateCategoriaRequest request,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = CategoriaResponse.fromJson(data);
      if (responseObj.data == null) {
        throw Exception('Error al actualizar la categoría');
      }
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al actualizar la categoría: $e');
    }
  }

  // Delete a category
  Future<DeleteCategoriaResponse> deleteCategoria(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return DeleteCategoriaResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al eliminar la categoría: $e');
    }
  }

  // Check if categories exist
  Future<bool> checkCategoriasExist() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/existen'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return data['exists'] ?? false;
    } catch (e) {
      print('Error al verificar existencia de categorías: $e');
      return false;
    }
  }

  // Get category by nemonico
  Future<Categoria> getCategoriaByNemonico(String nemonico) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/nemonico/$nemonico'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = CategoriaResponse.fromJson(data);
      if (responseObj.data == null) throw Exception('Categoría no encontrada');
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al obtener la categoría por nemónico: $e');
    }
  }
}
