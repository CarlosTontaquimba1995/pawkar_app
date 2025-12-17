// Model for Subcategoria entity with manual JSON serialization
class Subcategoria {
  final int subcategoriaId;
  final String nombre;
  final String descripcion;
  final String? fechaHora;
  final bool proximo;
  final int categoriaId;
  final String categoriaNombre;
  final bool estado;
  final String? deporte;
  final String? ubicacion;
  final double? latitud;
  final double? longitud;

  Subcategoria({
    required this.subcategoriaId,
    required this.nombre,
    required this.descripcion,
    this.fechaHora,
    required this.proximo,
    required this.categoriaId,
    required this.categoriaNombre,
    this.estado = true,
    this.deporte,
    this.ubicacion,
    this.latitud,
    this.longitud,
  }) : assert(nombre.isNotEmpty, 'Nombre cannot be empty'),
       assert(subcategoriaId > 0, 'SubcategoriaId must be positive');

  factory Subcategoria.fromJson(Map<String, dynamic> json) {
    try {
      final nombre = json['nombre'] as String?;
      final subcategoriaId = json['subcategoriaId'] as int?;
      final descripcion = json['descripcion'] as String?;
      final categoriaId = json['categoriaId'] as int?;
      final categoriaNombre = json['categoriaNombre'] as String?;
      final proximo = json['proximo'] as bool?;

      if (nombre == null || nombre.isEmpty) {
        throw ArgumentError('Invalid subcategoria: nombre cannot be null or empty');
      }
      if (subcategoriaId == null || subcategoriaId <= 0) {
        throw ArgumentError('Invalid subcategoria: subcategoriaId must be a positive integer');
      }
      if (descripcion == null || descripcion.isEmpty) {
        throw ArgumentError('Invalid subcategoria: descripcion cannot be null or empty');
      }
      if (categoriaId == null || categoriaId <= 0) {
        throw ArgumentError('Invalid subcategoria: categoriaId must be a positive integer');
      }
      if (categoriaNombre == null || categoriaNombre.isEmpty) {
        throw ArgumentError('Invalid subcategoria: categoriaNombre cannot be null or empty');
      }
      if (proximo == null) {
        throw ArgumentError('Invalid subcategoria: proximo cannot be null');
      }

      return Subcategoria(
        subcategoriaId: subcategoriaId,
        nombre: nombre,
        descripcion: descripcion,
        fechaHora: json['fechaHora'] as String?,
        proximo: proximo,
        categoriaId: categoriaId,
        categoriaNombre: categoriaNombre,
        estado: json['estado'] as bool? ?? true,
        deporte: json['deporte'] as String?,
        ubicacion: json['ubicacion'] as String?,
        latitud: json['latitud']?.toDouble(),
        longitud: json['longitud']?.toDouble(),
      );
    } catch (e) {
      throw FormatException('Error parsing Subcategoria from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'subcategoriaId': subcategoriaId,
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaHora': fechaHora,
      'proximo': proximo,
      'categoriaId': categoriaId,
      'categoriaNombre': categoriaNombre,
      'estado': estado,
      'deporte': deporte,
      'ubicacion': ubicacion,
      'latitud': latitud,
      'longitud': longitud,
    };
  }

  @override
  String toString() =>
      'Subcategoria(id: $subcategoriaId, nombre: $nombre, estado: $estado)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subcategoria &&
          runtimeType == other.runtimeType &&
          subcategoriaId == other.subcategoriaId &&
          nombre == other.nombre;

  @override
  int get hashCode => subcategoriaId.hashCode ^ nombre.hashCode;
}

class SubcategoriaListResponse {
  final bool success;
  final String message;
  final List<Subcategoria> data;
  final String timestamp;

  SubcategoriaListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory SubcategoriaListResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as List?;
      return SubcategoriaListResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: data != null
            ? data
                .map(
                  (item) => Subcategoria.fromJson(item as Map<String, dynamic>),
                )
                .toList()
            : [],
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid SubcategoriaListResponse JSON: $e');
    }
  }
}

class SubcategoriaResponse {
  final bool success;
  final String message;
  final Subcategoria? data;
  final String timestamp;

  SubcategoriaResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory SubcategoriaResponse.fromJson(Map<String, dynamic> json) {
    try {
      return SubcategoriaResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: json['data'] != null
            ? Subcategoria.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid SubcategoriaResponse JSON: $e');
    }
  }
}

class CreateSubcategoriaRequest {
  final String nombre;
  final String descripcion;
  final int categoriaId;
  final String? fechaHora;
  final bool? proximo;
  final bool? estado;
  final String? deporte;
  final String? ubicacion;

  CreateSubcategoriaRequest({
    required this.nombre,
    required this.descripcion,
    required this.categoriaId,
    this.fechaHora,
    this.proximo,
    this.estado,
    this.deporte,
    this.ubicacion,
  }) : assert(nombre.isNotEmpty, 'Nombre cannot be empty'),
       assert(descripcion.isNotEmpty, 'Descripción cannot be empty'),
       assert(categoriaId > 0, 'CategoriaId must be positive');

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'descripcion': descripcion,
        'categoriaId': categoriaId,
        if (fechaHora != null) 'fechaHora': fechaHora,
        if (proximo != null) 'proximo': proximo,
        if (estado != null) 'estado': estado,
        if (deporte != null) 'deporte': deporte,
        if (ubicacion != null) 'ubicacion': ubicacion,
      };
}

class CreateMultipleSubcategoriasRequest {
  final List<CreateSubcategoriaRequest> subcategorias;

  CreateMultipleSubcategoriasRequest({required this.subcategorias});

  Map<String, dynamic> toJson() => {
        'subcategorias': subcategorias.map((e) => e.toJson()).toList(),
      };
}

class UpdateSubcategoriaRequest {
  final String? nombre;
  final String? descripcion;
  final int? categoriaId;
  final String? fechaHora;
  final bool? proximo;
  final bool? estado;
  final String? deporte;
  final String? ubicacion;

  UpdateSubcategoriaRequest({
    this.nombre,
    this.descripcion,
    this.categoriaId,
    this.fechaHora,
    this.proximo,
    this.estado,
    this.deporte,
    this.ubicacion,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (nombre != null) json['nombre'] = nombre;
    if (descripcion != null) json['descripcion'] = descripcion;
    if (categoriaId != null) json['categoriaId'] = categoriaId;
    if (fechaHora != null) json['fechaHora'] = fechaHora;
    if (proximo != null) json['proximo'] = proximo;
    if (estado != null) json['estado'] = estado;
    if (deporte != null) json['deporte'] = deporte;
    if (ubicacion != null) json['ubicacion'] = ubicacion;
    return json;
  }
}

class DeleteSubcategoriaResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String timestamp;

  DeleteSubcategoriaResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory DeleteSubcategoriaResponse.fromJson(Map<String, dynamic> json) {
    try {
      return DeleteSubcategoriaResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: json['data'],
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid DeleteSubcategoriaResponse JSON: $e');
    }
  }
}
