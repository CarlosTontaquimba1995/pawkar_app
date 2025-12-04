import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../config/environment.dart';

class EventService {
  final String _baseUrl = '${Environment.baseUrl}/api/events';
  final http.Client _client;

  EventService({http.Client? client}) : _client = client ?? http.Client();

  /// Get headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  /// Handle API response errors
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw _handleError(response);
    }
  }

  /// Handle HTTP errors with appropriate messages
  Exception _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return Exception('Solicitud incorrecta: Verifique los datos enviados');
      case 401:
        return Exception('No autorizado: Por favor inicie sesión nuevamente');
      case 403:
        return Exception(
          'Acceso denegado: No tiene permisos para acceder a este recurso',
        );
      case 404:
        return Exception('Recurso no encontrado');
      case 500:
        return Exception('Error del servidor: Intente nuevamente más tarde');
      case 503:
        return Exception(
          'Servicio no disponible: Intente nuevamente más tarde',
        );
      default:
        return Exception('Error en la petición: ${response.statusCode}');
    }
  }

  /// Get all events
  Future<List<Event>> getEvents() async {
    try {
      final response = await _client
          .get(Uri.parse(_baseUrl), headers: await _getHeaders())
          .timeout(const Duration(seconds: 15));

      final data = _handleResponse(response);

      // Handle both wrapped and direct list responses
      if (data is List) {
        return (data)
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is Map && data['data'] != null) {
        final eventsList = data['data'] as List;
        return eventsList
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al obtener eventos: ${_extractErrorMessage(e)}');
    }
  }

  /// Get featured events
  Future<List<Event>> getFeaturedEvents() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/featured'), headers: await _getHeaders())
          .timeout(const Duration(seconds: 15));

      final data = _handleResponse(response);

      if (data is List) {
        return (data)
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is Map && data['data'] != null) {
        final eventsList = data['data'] as List;
        return eventsList
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception(
        'Error al obtener eventos destacados: ${_extractErrorMessage(e)}',
      );
    }
  }

  /// Get upcoming events
  Future<List<Event>> getUpcomingEvents({int limit = 10}) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/upcoming',
      ).replace(queryParameters: {'limit': limit.toString()});
      final response = await _client
          .get(uri, headers: await _getHeaders())
          .timeout(const Duration(seconds: 15));

      final data = _handleResponse(response);

      if (data is List) {
        return (data)
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is Map && data['data'] != null) {
        final eventsList = data['data'] as List;
        return eventsList
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception(
        'Error al obtener próximos eventos: ${_extractErrorMessage(e)}',
      );
    }
  }

  /// Get events by category
  Future<List<Event>> getEventsByCategory(String category) async {
    if (category.isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }

    try {
      final uri = Uri.parse('$_baseUrl/category/$category');
      final response = await _client
          .get(uri, headers: await _getHeaders())
          .timeout(const Duration(seconds: 15));

      final data = _handleResponse(response);

      if (data is List) {
        return (data)
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is Map && data['data'] != null) {
        final eventsList = data['data'] as List;
        return eventsList
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception(
        'Error al obtener eventos de la categoría: ${_extractErrorMessage(e)}',
      );
    }
  }

  /// Get a single event by ID
  Future<Event> getEventById(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Event id cannot be empty');
    }

    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/$id'), headers: await _getHeaders())
          .timeout(const Duration(seconds: 15));

      final data = _handleResponse(response);

      if (data is Map) {
        final eventData = data['data'] ?? data;
        return Event.fromJson(eventData as Map<String, dynamic>);
      }
      throw ArgumentError('Invalid event response format');
    } catch (e) {
      throw Exception('Error al obtener el evento: ${_extractErrorMessage(e)}');
    }
  }

  /// Search events by title
  Future<List<Event>> searchEvents(String query) async {
    if (query.isEmpty) {
      throw ArgumentError('Search query cannot be empty');
    }

    try {
      final uri = Uri.parse(
        '$_baseUrl/search',
      ).replace(queryParameters: {'q': query});
      final response = await _client
          .get(uri, headers: await _getHeaders())
          .timeout(const Duration(seconds: 15));

      final data = _handleResponse(response);

      if (data is List) {
        return (data)
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is Map && data['data'] != null) {
        final eventsList = data['data'] as List;
        return eventsList
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al buscar eventos: ${_extractErrorMessage(e)}');
    }
  }

  /// Create a new event (admin only)
  Future<Event> createEvent(Map<String, dynamic> eventData) async {
    if (eventData.isEmpty) {
      throw ArgumentError('Event data cannot be empty');
    }

    try {
      final response = await _client
          .post(
            Uri.parse(_baseUrl),
            headers: await _getHeaders(),
            body: jsonEncode(eventData),
          )
          .timeout(const Duration(seconds: 15));

      final data = _handleResponse(response);
      final eventJson = data is Map ? (data['data'] ?? data) : data;
      return Event.fromJson(eventJson as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al crear el evento: ${_extractErrorMessage(e)}');
    }
  }

  /// Update an event (admin only)
  Future<Event> updateEvent(String id, Map<String, dynamic> eventData) async {
    if (id.isEmpty) {
      throw ArgumentError('Event id cannot be empty');
    }
    if (eventData.isEmpty) {
      throw ArgumentError('Event data cannot be empty');
    }

    try {
      final response = await _client
          .put(
            Uri.parse('$_baseUrl/$id'),
            headers: await _getHeaders(),
            body: jsonEncode(eventData),
          )
          .timeout(const Duration(seconds: 15));

      final data = _handleResponse(response);
      final eventJson = data is Map ? (data['data'] ?? data) : data;
      return Event.fromJson(eventJson as Map<String, dynamic>);
    } catch (e) {
      throw Exception(
        'Error al actualizar el evento: ${_extractErrorMessage(e)}',
      );
    }
  }

  /// Delete an event (admin only)
  Future<void> deleteEvent(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Event id cannot be empty');
    }

    try {
      final response = await _client
          .delete(Uri.parse('$_baseUrl/$id'), headers: await _getHeaders())
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception(
        'Error al eliminar el evento: ${_extractErrorMessage(e)}',
      );
    }
  }

  /// Helper method to extract error message from exception
  String _extractErrorMessage(dynamic error) {
    if (error is Exception) {
      final message = error.toString();
      return message.replaceFirst('Exception: ', '');
    }
    return error.toString();
  }
}
