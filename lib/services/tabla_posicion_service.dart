import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tabla_posicion_model.dart';
import '../config/environment.dart';

class TablaPosicionService {
  final String _baseUrl = '${Environment.baseUrl}/api/tabla-posicion';
  final http.Client _client;

  TablaPosicionService({http.Client? client})
    : _client = client ?? http.Client();

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

  /// Obtiene la posición específica de un equipo en la tabla de posiciones de una subcategoría
  /// [subcategoriaId] ID de la subcategoría
  /// [equipoId] ID del equipo
  Future<EquipoPosicion> getPosicionEquipo(
    int subcategoriaId,
    int equipoId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/subcategoria/$subcategoriaId/equipo/$equipoId'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = EquipoPosicionResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener la posición del equipo: $e');
    }
  }

  /// Obtiene la tabla de posiciones para una subcategoría específica
  /// [subcategoriaId] ID de la subcategoría
  Future<List<TablaPosicion>> getBySubcategoria(int subcategoriaId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/subcategoria/$subcategoriaId'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = TablaPosicionResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener la tabla de posiciones: $e');
    }
  }

  /// Busca en la tabla de posiciones con múltiples criterios
  /// [params] Parámetros de búsqueda
  Future<List<TablaPosicion>> search(SearchParams params) async {
    try {
      // Convert params to query parameters, ensuring all values are strings
      final paramsMap = params.toJson();
      final queryParams = <String, String>{};

      paramsMap.forEach((key, value) {
        if (value != null) {
          queryParams[key] = value.toString();
        }
      });

      final uri = Uri.parse(
        '$_baseUrl/search',
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await _client.get(uri, headers: await _getHeaders());

      final data = _handleResponse(response);
      print('=== RESPUESTA DE LA API TABLA DE POSICIONES ===');
      print('URL: $uri');
      print('Respuesta: $data');
      print('===============================================');
      
      final responseObj = TablaPosicionResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al buscar en la tabla de posiciones: $e');
    }
  }

  /// Elimina una posición de la tabla
  /// [subcategoriaId] ID de la subcategoría
  /// [equipoId] ID del equipo
  Future<void> delete(int subcategoriaId, int equipoId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/subcategoria/$subcategoriaId/equipo/$equipoId'),
        headers: await _getHeaders(),
      );
      _handleResponse(response);
    } catch (e) {
      throw Exception('Error al eliminar la posición: $e');
    }
  }

  /// Actualiza la tabla de posiciones desde un partido
  /// [data] Datos del partido para actualizar la tabla
  Future<void> actualizarDesdePartido(
    ActualizarDesdePartidoRequest data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/actualizar-desde-partido'),
        headers: await _getHeaders(),
        body: json.encode(data.toJson()),
      );
      _handleResponse(response);
    } catch (e) {
      throw Exception('Error al actualizar desde partido: $e');
    }
  }
}
