import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subcategoria_model.dart';
import '../config/environment.dart';

class SubcategoriaService {
  final String _baseUrl = '${Environment.baseUrl}/api/subcategorias';
  final http.Client _client;

  SubcategoriaService({http.Client? client}) : _client = client ?? http.Client();

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

  // Get all subcategories
  Future<List<Subcategoria>> getSubcategorias() async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = SubcategoriaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener subcategorías: $e');
    }
  }

  // Get subcategory by ID
  Future<Subcategoria> getSubcategoriaById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = SubcategoriaResponse.fromJson(data);
      if (responseObj.data == null) throw Exception('Subcategoría no encontrada');
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al obtener la subcategoría: $e');
    }
  }

  // Get subcategories by category ID
  Future<List<Subcategoria>> getSubcategoriasByCategoria(int categoriaId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/categoria/$categoriaId'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = SubcategoriaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener subcategorías por categoría: $e');
    }
  }

  // Create a new subcategory
  Future<Subcategoria> createSubcategoria(CreateSubcategoriaRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = SubcategoriaResponse.fromJson(data);
      if (responseObj.data == null) {
        throw Exception('Error al crear la subcategoría');
      }
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al crear la subcategoría: $e');
    }
  }

  // Create multiple subcategories
  Future<List<Subcategoria>> createMultipleSubcategorias(
    CreateMultipleSubcategoriasRequest request,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bulk'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = SubcategoriaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear múltiples subcategorías: $e');
    }
  }

  // Update a subcategory
  Future<Subcategoria> updateSubcategoria(
    int id,
    UpdateSubcategoriaRequest request,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = SubcategoriaResponse.fromJson(data);
      if (responseObj.data == null) {
        throw Exception('Error al actualizar la subcategoría');
      }
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al actualizar la subcategoría: $e');
    }
  }

  // Delete a subcategory
  Future<DeleteSubcategoriaResponse> deleteSubcategoria(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return DeleteSubcategoriaResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al eliminar la subcategoría: $e');
    }
  }

  // Get upcoming events (subcategorías with proximo = true)
  Future<List<Subcategoria>> getProximosEventos() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/eventos/proximos'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = SubcategoriaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener próximos eventos: $e');
    }
  }

  // Get past events (subcategorías with proximo = false)
  Future<List<Subcategoria>> getEventosPasados() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/eventos/pasados'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = SubcategoriaListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener eventos pasados: $e');
    }
  }

  // Legacy methods for backward compatibility
  Future<List<Subcategoria>> getCategories() => getSubcategorias();
  
  Future<Subcategoria> createCategory(CreateSubcategoriaRequest request) => 
      createSubcategoria(request);
      
  Future<Subcategoria> updateCategory(int id, UpdateSubcategoriaRequest request) => 
      updateSubcategoria(id, request);
      
  Future<DeleteSubcategoriaResponse> deleteCategory(int id) => 
      deleteSubcategoria(id);
      
  Future<Subcategoria> getCategoryById(int id) => getSubcategoriaById(id);
}
