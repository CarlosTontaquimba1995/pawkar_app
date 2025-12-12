import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jugador_model.dart';
import '../config/environment.dart';

class JugadorService {
  final String _baseUrl = '${Environment.baseUrl}/api/jugadores';
  final http.Client _client;

  JugadorService({http.Client? client}) : _client = client ?? http.Client();

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
        throw Exception('Jugador no encontrado');
      case 500:
        throw Exception('Error interno del servidor');
      default:
        throw Exception(
          'Error al procesar la solicitud: ${response.statusCode}',
        );
    }
  }

  /// Obtiene una lista paginada de jugadores con opciones de búsqueda y ordenamiento
  /// [params] Parámetros de consulta para paginación, ordenamiento y búsqueda
  Future<JugadorListResponse> getJugadores(
      {JugadorQueryParams? params}) async {
    try {
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: params?.toJson(),
      );
      
      final response = await _client.get(
        uri,
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return JugadorListResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener jugadores: $e');
    }
  }

  /// Obtiene el conteo total de jugadores activos
  Future<JugadorCountResponse> getConteoJugadoresActivos() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/count'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return JugadorCountResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener el conteo de jugadores activos: $e');
    }
  }

  /// Obtiene un jugador por su ID
  /// [id] ID del jugador a buscar
  Future<Jugador> getJugadorPorId(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      final responseObj = JugadorResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al obtener el jugador con id $id: $e');
    }
  }

  /// Crea un nuevo jugador
  /// [jugadorData] Datos del jugador a crear
  Future<Jugador> crearJugador(CreateJugadorRequest jugadorData) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(jugadorData.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = JugadorResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al crear el jugador: $e');
    }
  }

  /// Actualiza un jugador existente
  /// [id] ID del jugador a actualizar
  /// [jugadorData] Datos actualizados del jugador
  Future<Jugador> actualizarJugador(
    int id,
    UpdateJugadorRequest jugadorData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
        body: json.encode(jugadorData.toJson()),
      );

      final data = _handleResponse(response);
      final responseObj = JugadorResponse.fromJson(data);
      return responseObj.data;
    } catch (e) {
      throw Exception('Error al actualizar el jugador con id $id: $e');
    }
  }

  /// Elimina un jugador
  /// [id] ID del jugador a eliminar
  Future<void> eliminarJugador(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );

      _handleResponse(response);
    } catch (e) {
      throw Exception('Error al eliminar el jugador con id $id: $e');
    }
  }

  /// Crea múltiples jugadores en una sola petición
  /// [data] Objeto que contiene el array de jugadores a crear
  Future<List<Jugador>> crearMultiplesJugadores(
      CreateMultipleJugadoresRequest data) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bulk'),
        headers: await _getHeaders(),
        body: json.encode(data.toJson()),
      );

      final responseData = _handleResponse(response);
      final responseObj = JugadorListResponse.fromJson(responseData);
      return responseObj.content;
    } catch (e) {
      throw Exception('Error al crear múltiples jugadores: $e');
    }
  }
}
