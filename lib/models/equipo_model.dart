class Equipo {
  final int equipoId;
  final int subcategoriaId;
  final String subcategoriaNombre;
  final int serieId;
  final String serieNombre;
  final String nombre;
  final String fundacion;
  final int jugadoresCount;
  final bool estado;

  Equipo({
    required this.equipoId,
    required this.subcategoriaId,
    required this.subcategoriaNombre,
    required this.serieId,
    required this.serieNombre,
    required this.nombre,
    required this.fundacion,
    required this.jugadoresCount,
    this.estado = true,
  }) : assert(nombre.isNotEmpty, 'Nombre cannot be empty'),
       assert(equipoId > 0, 'EquipoId must be positive'),
       assert(subcategoriaId > 0, 'SubcategoriaId must be positive'),
       assert(serieId > 0, 'SerieId must be positive');

  factory Equipo.fromJson(Map<String, dynamic> json) {
    final nombre = json['nombre'] as String?;
    final equipoId = json['equipoId'] as int?;
    final subcategoriaId = json['subcategoriaId'] as int?;
    final serieId = json['serieId'] as int?;

    if (nombre == null || nombre.isEmpty) {
      throw ArgumentError('Invalid equipo: nombre cannot be null or empty');
    }
    if (equipoId == null || equipoId <= 0) {
      throw ArgumentError(
        'Invalid equipo: equipoId must be a positive integer',
      );
    }
    if (subcategoriaId == null || subcategoriaId <= 0) {
      throw ArgumentError(
        'Invalid equipo: subcategoriaId must be a positive integer',
      );
    }
    if (serieId == null || serieId <= 0) {
      throw ArgumentError('Invalid equipo: serieId must be a positive integer');
    }

    return Equipo(
      equipoId: equipoId,
      subcategoriaId: subcategoriaId,
      subcategoriaNombre: (json['subcategoriaNombre'] as String?) ?? '',
      serieId: serieId,
      serieNombre: (json['serieNombre'] as String?) ?? '',
      nombre: nombre,
      fundacion: (json['fundacion'] as String?) ?? '',
      jugadoresCount: (json['jugadoresCount'] as int?) ?? 0,
      estado: (json['estado'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipoId': equipoId,
      'subcategoriaId': subcategoriaId,
      'subcategoriaNombre': subcategoriaNombre,
      'serieId': serieId,
      'serieNombre': serieNombre,
      'nombre': nombre,
      'fundacion': fundacion,
      'jugadoresCount': jugadoresCount,
      'estado': estado,
    };
  }

  @override
  String toString() =>
      'Equipo(id: $equipoId, nombre: $nombre, estado: $estado)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Equipo &&
          runtimeType == other.runtimeType &&
          equipoId == other.equipoId &&
          nombre == other.nombre;

  @override
  int get hashCode => equipoId.hashCode ^ nombre.hashCode;
}

class EquipoListResponse {
  final bool success;
  final String message;
  final List<Equipo> data;
  final String timestamp;

  EquipoListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory EquipoListResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as List?;
      return EquipoListResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: data != null
            ? data
                  .map((item) => Equipo.fromJson(item as Map<String, dynamic>))
                  .toList()
            : [],
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid EquipoListResponse JSON: $e');
    }
  }
}

class EquipoResponse {
  final bool success;
  final String message;
  final Equipo data;
  final String timestamp;

  EquipoResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory EquipoResponse.fromJson(Map<String, dynamic> json) {
    try {
      return EquipoResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: Equipo.fromJson(json['data'] as Map<String, dynamic>),
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid EquipoResponse JSON: $e');
    }
  }
}

class CreateEquipoRequest {
  final int subcategoriaId;
  final int serieId;
  final String nombre;
  final bool estado;

  CreateEquipoRequest({
    required this.subcategoriaId,
    required this.serieId,
    required this.nombre,
    this.estado = true,
  }) : assert(nombre.isNotEmpty, 'Nombre cannot be empty'),
       assert(subcategoriaId > 0, 'SubcategoriaId must be positive'),
       assert(serieId > 0, 'SerieId must be positive');

  Map<String, dynamic> toJson() {
    return {
      'subcategoriaId': subcategoriaId,
      'serieId': serieId,
      'nombre': nombre,
      'estado': estado,
    };
  }
}

class CreateMultipleEquiposRequest {
  final List<CreateEquipoRequest> equipos;

  CreateMultipleEquiposRequest({required this.equipos});

  Map<String, dynamic> toJson() {
    return {'equipos': equipos.map((e) => e.toJson()).toList()};
  }
}

class UpdateEquipoRequest {
  final int? subcategoriaId;
  final int? serieId;
  final String? nombre;
  final bool? estado;

  UpdateEquipoRequest({
    this.subcategoriaId,
    this.serieId,
    this.nombre,
    this.estado,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (subcategoriaId != null) json['subcategoriaId'] = subcategoriaId;
    if (serieId != null) json['serieId'] = serieId;
    if (nombre != null) json['nombre'] = nombre;
    if (estado != null) json['estado'] = estado;
    return json;
  }
}

class DeleteEquipoResponse {
  final bool success;
  final String message;
  final int equipoId;
  final String timestamp;

  DeleteEquipoResponse({
    required this.success,
    required this.message,
    required this.equipoId,
    required this.timestamp,
  });

  factory DeleteEquipoResponse.fromJson(Map<String, dynamic> json) {
    try {
      return DeleteEquipoResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        equipoId: (json['equipoId'] as int?) ?? 0,
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid DeleteEquipoResponse JSON: $e');
    }
  }
}
