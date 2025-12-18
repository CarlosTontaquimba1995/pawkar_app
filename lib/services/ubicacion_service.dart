import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ubicacion_model.dart';
import '../config/environment.dart';

class UbicacionService {
  final String _baseUrl = '${Environment.baseUrl}/api/ubicaciones';
  final http.Client _client;

  UbicacionService({http.Client? client}) : _client = client ?? http.Client();

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
        throw Exception('Ubicación no encontrada');
      case 500:
        throw Exception('Error interno del servidor');
      default:
        throw Exception(
          'Error al procesar la solicitud: ${response.statusCode}',
        );
    }
  }

  // Get all locations
  Future<List<Ubicacion>> getUbicaciones() async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = UbicacionListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener ubicaciones: $e');
    }
  }

  // Get location by ID
  Future<Ubicacion> getUbicacionById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = UbicacionResponse.fromJson(data);
      if (responseObj.data == null) throw Exception('Ubicación no encontrada');
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al obtener la ubicación: $e');
    }
  }

  // Get location by nemonico
  Future<Ubicacion> getUbicacionByNemonico(String nemonico) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/nemonico/$nemonico'),
        headers: _getPublicHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = UbicacionResponse.fromJson(data);
      if (responseObj.data == null) throw Exception('Ubicación no encontrada');
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al obtener la ubicación por nemónico: $e');
    }
  }

  // Create a new location
  Future<Ubicacion> createUbicacion(CreateUbicacionRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = UbicacionResponse.fromJson(data);
      if (responseObj.data == null) {
        throw Exception('Error al crear la ubicación');
      }
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al crear la ubicación: $e');
    }
  }

  // Create multiple locations
  Future<List<Ubicacion>> createMultipleUbicaciones(
    List<CreateUbicacionRequest> ubicaciones,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bulk'),
        headers: await _getHeaders(),
        body: json.encode({
          'ubicaciones': ubicaciones.map((u) => u.toJson()).toList(),
        }),
      );

      final data = _handleResponse(response);
      final responseObj = UbicacionListResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear las ubicaciones: $e');
    }
  }

  // Update a location
  Future<Ubicacion> updateUbicacion(UpdateUbicacionRequest request) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/${request.ubicacionId}'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = UbicacionResponse.fromJson(data);
      if (responseObj.data == null) {
        throw Exception('Error al actualizar la ubicación');
      }
      return responseObj.data!;
    } catch (e) {
      throw Exception('Error al actualizar la ubicación: $e');
    }
  }

  // Delete a location
  Future<void> deleteUbicacion(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );

      _handleResponse(response);
    } catch (e) {
      throw Exception('Error al eliminar la ubicación: $e');
    }
  }
}
