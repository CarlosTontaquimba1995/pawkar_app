class Categoria {
  final int categoriaId;
  final String nombre;
  final String? nemonico;
  final bool? estado;

  Categoria({
    required this.categoriaId,
    required this.nombre,
    this.nemonico,
    this.estado = true,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      categoriaId: json['categoriaId'],
      nombre: json['nombre'],
      nemonico: json['nemonico'],
      estado: json['estado'] ?? true,
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
    return CategoriaListResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => Categoria.fromJson(item))
          .toList(),
      timestamp: json['timestamp'],
    );
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
    return CategoriaResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? Categoria.fromJson(json['data']) : null,
      timestamp: json['timestamp'],
    );
  }
}

class CreateCategoriaRequest {
  final String nombre;

  CreateCategoriaRequest({required this.nombre});

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
      };
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

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
      };
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
    return DeleteCategoriaResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'],
      timestamp: json['timestamp'],
    );
  }
}
