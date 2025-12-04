class Categoria {
  final int categoriaId;
  final String nombre;
  final String? nemonico;
  final bool estado;

  Categoria({
    required this.categoriaId,
    required this.nombre,
    this.nemonico,
    this.estado = true,
  }) : assert(nombre.isNotEmpty, 'Nombre cannot be empty'),
       assert(categoriaId > 0, 'CategoriaId must be positive');

  factory Categoria.fromJson(Map<String, dynamic> json) {
    final nombre = json['nombre'] as String?;
    final categoriaId = json['categoriaId'] as int?;

    if (nombre == null || nombre.isEmpty) {
      throw ArgumentError('Invalid categoria: nombre cannot be null or empty');
    }
    if (categoriaId == null || categoriaId <= 0) {
      throw ArgumentError(
        'Invalid categoria: categoriaId must be a positive integer',
      );
    }

    return Categoria(
      categoriaId: categoriaId,
      nombre: nombre,
      nemonico: (json['nemonico'] as String?)?.isNotEmpty == true
          ? json['nemonico'] as String
          : null,
      estado: (json['estado'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoriaId': categoriaId,
      'nombre': nombre,
      'nemonico': nemonico,
      'estado': estado,
    };
  }

  @override
  String toString() =>
      'Categoria(id: $categoriaId, nombre: $nombre, estado: $estado)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Categoria &&
          runtimeType == other.runtimeType &&
          categoriaId == other.categoriaId &&
          nombre == other.nombre;

  @override
  int get hashCode => categoriaId.hashCode ^ nombre.hashCode;
}

class CategoriaListResponse {
  final bool success;
  final String message;
  final List<Categoria> data;
  final String timestamp;

  CategoriaListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory CategoriaListResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as List?;
      return CategoriaListResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: data != null
            ? data
                  .map(
                    (item) => Categoria.fromJson(item as Map<String, dynamic>),
                  )
                  .toList()
            : [],
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid CategoriaListResponse JSON: $e');
    }
  }
}

class CategoriaResponse {
  final bool success;
  final String message;
  final Categoria? data;
  final String timestamp;

  CategoriaResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory CategoriaResponse.fromJson(Map<String, dynamic> json) {
    try {
      return CategoriaResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: json['data'] != null
            ? Categoria.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid CategoriaResponse JSON: $e');
    }
  }
}

class CreateCategoriaRequest {
  final String nombre;

  CreateCategoriaRequest({required this.nombre});

  Map<String, dynamic> toJson() => {'nombre': nombre};
}

class CreateMultipleCategoriasRequest {
  final List<CreateCategoriaRequest> categorias;

  CreateMultipleCategoriasRequest({required this.categorias});

  Map<String, dynamic> toJson() => {
    'categorias': categorias.map((e) => e.toJson()).toList(),
  };
}

class UpdateCategoriaRequest {
  final String nombre;

  UpdateCategoriaRequest({required this.nombre});

  Map<String, dynamic> toJson() => {'nombre': nombre};
}

class DeleteCategoriaResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String timestamp;

  DeleteCategoriaResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory DeleteCategoriaResponse.fromJson(Map<String, dynamic> json) {
    try {
      return DeleteCategoriaResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: json['data'],
        timestamp:
            (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid DeleteCategoriaResponse JSON: $e');
    }
  }
}
