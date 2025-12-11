class Estadio {
  final int id;
  final String nombre;
  final String detalle;
  final bool estado;

  Estadio({
    required this.id,
    required this.nombre,
    required this.detalle,
    this.estado = true,
  })  : assert(nombre.isNotEmpty, 'Nombre cannot be empty'),
        assert(id > 0, 'Id must be positive');

  factory Estadio.fromJson(Map<String, dynamic> json) {
    final nombre = json['nombre'] as String?;
    final id = json['id'] as int?;

    if (nombre == null || nombre.isEmpty) {
      throw ArgumentError('Invalid estadio: nombre cannot be null or empty');
    }
    if (id == null || id <= 0) {
      throw ArgumentError('Invalid estadio: id must be a positive integer');
    }

    return Estadio(
      id: id,
      nombre: nombre,
      detalle: (json['detalle'] as String?) ?? '',
      estado: (json['estado'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'detalle': detalle,
      'estado': estado,
    };
  }

  @override
  String toString() => 'Estadio(id: $id, nombre: $nombre, estado: $estado)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Estadio &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre;

  @override
  int get hashCode => id.hashCode ^ nombre.hashCode;
}

class EstadioListResponse {
  final bool success;
  final String message;
  final List<Estadio> data;
  final String timestamp;

  EstadioListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory EstadioListResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as List?;
      return EstadioListResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: data != null
            ? data
                .map((item) => Estadio.fromJson(item as Map<String, dynamic>))
                .toList()
            : [],
        timestamp: (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid EstadioListResponse JSON: $e');
    }
  }
}

class EstadioResponse {
  final bool success;
  final String message;
  final Estadio data;
  final String timestamp;

  EstadioResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory EstadioResponse.fromJson(Map<String, dynamic> json) {
    try {
      return EstadioResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: Estadio.fromJson(json['data'] as Map<String, dynamic>),
        timestamp: (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid EstadioResponse JSON: $e');
    }
  }
}

class CreateEstadioRequest {
  final String nombre;
  final String detalle;
  final bool estado;

  CreateEstadioRequest({
    required this.nombre,
    required this.detalle,
    this.estado = true,
  }) : assert(nombre.isNotEmpty, 'Nombre cannot be empty');

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'detalle': detalle,
      'estado': estado,
    };
  }
}

class UpdateEstadioRequest {
  final String? nombre;
  final String? detalle;
  final bool? estado;

  UpdateEstadioRequest({
    this.nombre,
    this.detalle,
    this.estado,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (nombre != null) json['nombre'] = nombre;
    if (detalle != null) json['detalle'] = detalle;
    if (estado != null) json['estado'] = estado;
    return json;
  }
}

class CreateBulkEstadiosRequest {
  final List<CreateEstadioRequest> estadios;

  CreateBulkEstadiosRequest({required this.estadios});

  Map<String, dynamic> toJson() {
    return {
      'estadios': estadios.map((e) => e.toJson()).toList(),
    };
  }
}

class DeleteEstadioResponse {
  final bool success;
  final String message;
  final String timestamp;

  DeleteEstadioResponse({
    required this.success,
    required this.message,
    required this.timestamp,
  });

  factory DeleteEstadioResponse.fromJson(Map<String, dynamic> json) {
    try {
      return DeleteEstadioResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        timestamp: (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid DeleteEstadioResponse JSON: $e');
    }
  }
}
