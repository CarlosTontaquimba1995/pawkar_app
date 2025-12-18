class Ubicacion {
  final int ubicacionId;
  final String descripcion;
  final String? nemonico;
  final bool estado;
  final double? latitud;
  final double? longitud;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Ubicacion({
    required this.ubicacionId,
    required this.descripcion,
    this.nemonico,
    this.estado = true,
    this.latitud,
    this.longitud,
    this.createdAt,
    this.updatedAt,
  }) : assert(descripcion.isNotEmpty, 'Descripción no puede estar vacía'),
       assert(ubicacionId > 0, 'ubicacionId debe ser un número positivo');

  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    final descripcion = json['descripcion'] as String?;
    final ubicacionId = json['id'] as int?;

    if (descripcion == null || descripcion.isEmpty) {
      throw ArgumentError(
        'Ubicación inválida: la descripción no puede estar vacía',
      );
    }
    if (ubicacionId == null || ubicacionId <= 0) {
      throw ArgumentError(
        'Ubicación inválida: el ID debe ser un número entero positivo',
      );
    }

    return Ubicacion(
      ubicacionId: ubicacionId,
      descripcion: descripcion,
      nemonico: json['nemonico'] as String?,
      estado: (json['estado'] as bool?) ?? true,
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': ubicacionId,
      'descripcion': descripcion,
      'nemonico': nemonico,
      'estado': estado,
      'latitud': latitud,
      'longitud': longitud,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'Ubicacion(id: $ubicacionId, descripcion: $descripcion, estado: $estado)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ubicacion &&
          runtimeType == other.runtimeType &&
          ubicacionId == other.ubicacionId &&
          descripcion == other.descripcion;

  @override
  int get hashCode => ubicacionId.hashCode ^ descripcion.hashCode;
}

class UbicacionListResponse {
  final bool success;
  final String message;
  final List<Ubicacion> data;
  final String timestamp;

  UbicacionListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory UbicacionListResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as List?;
      return UbicacionListResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'Sin mensaje',
        data: data != null
            ? data
                  .map(
                    (item) => Ubicacion.fromJson(item as Map<String, dynamic>),
                  )
                  .toList()
            : [],
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Respuesta de lista de ubicaciones inválida: $e');
    }
  }
}

class UbicacionResponse {
  final bool success;
  final String message;
  final Ubicacion? data;
  final String timestamp;

  UbicacionResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory UbicacionResponse.fromJson(Map<String, dynamic> json) {
    try {
      return UbicacionResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'Sin mensaje',
        data: json['data'] != null
            ? Ubicacion.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Respuesta de ubicación inválida: $e');
    }
  }
}

class CreateUbicacionRequest {
  final String descripcion;
  final String? nemonico;
  final bool estado;
  final double? latitud;
  final double? longitud;

  CreateUbicacionRequest({
    required this.descripcion,
    this.nemonico,
    this.estado = true,
    this.latitud,
    this.longitud,
  }) : assert(descripcion.isNotEmpty, 'La descripción no puede estar vacía');

  Map<String, dynamic> toJson() {
    return {
      'descripcion': descripcion,
      if (nemonico != null) 'nemonico': nemonico,
      'estado': estado,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
    };
  }
}

class UpdateUbicacionRequest {
  final int ubicacionId;
  final String? descripcion;
  final String? nemonico;
  final bool? estado;
  final double? latitud;
  final double? longitud;

  UpdateUbicacionRequest({
    required this.ubicacionId,
    this.descripcion,
    this.nemonico,
    this.estado,
    this.latitud,
    this.longitud,
  }) : assert(
         ubicacionId > 0,
         'El ID de ubicación debe ser un número positivo',
       );

  Map<String, dynamic> toJson() {
    return {
      'id': ubicacionId,
      if (descripcion != null) 'descripcion': descripcion,
      if (nemonico != null) 'nemonico': nemonico,
      if (estado != null) 'estado': estado,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
    };
  }
}

class DeleteUbicacionResponse {
  final bool success;
  final String message;
  final int? ubicacionId;
  final String timestamp;

  DeleteUbicacionResponse({
    required this.success,
    required this.message,
    this.ubicacionId,
    required this.timestamp,
  });

  factory DeleteUbicacionResponse.fromJson(Map<String, dynamic> json) {
    return DeleteUbicacionResponse(
      success: (json['success'] as bool?) ?? false,
      message: (json['message'] as String?) ?? 'Sin mensaje',
      ubicacionId: json['ubicacionId'] as int?,
      timestamp:
          (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
    );
  }
}
