import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/estadio_model.dart';
import '../config/environment.dart';

class EstadioService {
  final String _baseUrl = '${Environment.baseUrl}/api/estadios';
  final http.Client _client;

  EstadioService({http.Client? client}) : _client = client ?? http.Client();

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

  // Obtiene todos los estadios
  Future<List<Estadio>> getAllEstadios() async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = EstadioListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener los estadios: $e');
    }
  }

  // Obtiene un estadio por su ID
  Future<Estadio> getEstadioById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = EstadioResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener el estadio: $e');
    }
  }

  // Crea un nuevo estadio
  Future<Estadio> createEstadio(CreateEstadioRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = EstadioResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear el estadio: $e');
    }
  }

  // Actualiza un estadio existente
  Future<Estadio> updateEstadio(int id, UpdateEstadioRequest request) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = EstadioResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al actualizar el estadio: $e');
    }
  }

  // Elimina un estadio
  Future<DeleteEstadioResponse> deleteEstadio(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return DeleteEstadioResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al eliminar el estadio: $e');
    }
  }

  // Crea múltiples estadios en una sola operación
  Future<List<Estadio>> createBulkEstadios(
    CreateBulkEstadiosRequest request,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bulk'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = EstadioListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear los estadios: $e');
    }
  }
}
