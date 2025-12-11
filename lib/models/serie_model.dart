class Serie {
  final int serieId;
  final int subcategoriaId;
  final String subcategoriaNombre;
  final String nombreSerie;
  final bool estado;

  Serie({
    required this.serieId,
    required this.subcategoriaId,
    required this.subcategoriaNombre,
    required this.nombreSerie,
    this.estado = true,
  })  : assert(nombreSerie.isNotEmpty, 'Nombre de serie cannot be empty'),
        assert(serieId > 0, 'serieId must be positive'),
        assert(subcategoriaId > 0, 'subcategoriaId must be positive');

  factory Serie.fromJson(Map<String, dynamic> json) {
    final nombreSerie = json['nombreSerie'] as String?;
    final serieId = json['serieId'] as int?;
    final subcategoriaId = json['subcategoriaId'] as int?;

    if (nombreSerie == null || nombreSerie.isEmpty) {
      throw ArgumentError('Invalid serie: nombreSerie cannot be null or empty');
    }
    if (serieId == null || serieId <= 0) {
      throw ArgumentError('Invalid serie: serieId must be a positive integer');
    }
    if (subcategoriaId == null || subcategoriaId <= 0) {
      throw ArgumentError('Invalid serie: subcategoriaId must be a positive integer');
    }

    return Serie(
      serieId: serieId,
      subcategoriaId: subcategoriaId,
      subcategoriaNombre: (json['subcategoriaNombre'] as String?) ?? '',
      nombreSerie: nombreSerie,
      estado: (json['estado'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serieId': serieId,
      'subcategoriaId': subcategoriaId,
      'subcategoriaNombre': subcategoriaNombre,
      'nombreSerie': nombreSerie,
      'estado': estado,
    };
  }

  @override
  String toString() => 'Serie(id: $serieId, nombre: $nombreSerie, estado: $estado)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Serie &&
          runtimeType == other.runtimeType &&
          serieId == other.serieId &&
          nombreSerie == other.nombreSerie;

  @override
  int get hashCode => serieId.hashCode ^ nombreSerie.hashCode;
}

class CreateSerieRequest {
  final String nombreSerie;
  final int subcategoriaId;

  CreateSerieRequest({
    required this.nombreSerie,
    required this.subcategoriaId,
  })  : assert(nombreSerie.isNotEmpty, 'Nombre de serie cannot be empty'),
        assert(subcategoriaId > 0, 'subcategoriaId must be positive');

  Map<String, dynamic> toJson() {
    return {
      'nombreSerie': nombreSerie,
      'subcategoriaId': subcategoriaId,
    };
  }
}

class CreateMultipleSeriesRequest {
  final List<CreateSerieRequest> series;

  CreateMultipleSeriesRequest({required this.series});

  Map<String, dynamic> toJson() {
    return {
      'series': series.map((e) => e.toJson()).toList(),
    };
  }
}

class UpdateSerieRequest {
  final String? nombreSerie;
  final String? descripcion;
  final int? subcategoriaId;

  UpdateSerieRequest({
    this.nombreSerie,
    this.descripcion,
    this.subcategoriaId,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (nombreSerie != null) json['nombreSerie'] = nombreSerie;
    if (descripcion != null) json['descripcion'] = descripcion;
    if (subcategoriaId != null) json['subcategoriaId'] = subcategoriaId;
    return json;
  }
}

class SerieResponse {
  final bool success;
  final String message;
  final Serie data;
  final String timestamp;

  SerieResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory SerieResponse.fromJson(Map<String, dynamic> json) {
    try {
      return SerieResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: Serie.fromJson(json['data'] as Map<String, dynamic>),
        timestamp: (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid SerieResponse JSON: $e');
    }
  }
}

class SerieListResponse {
  final bool success;
  final String message;
  final List<Serie> data;
  final String timestamp;

  SerieListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory SerieListResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as List?;
      return SerieListResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: data != null
            ? data
                .map((item) => Serie.fromJson(item as Map<String, dynamic>))
                .toList()
            : [],
        timestamp: (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid SerieListResponse JSON: $e');
    }
  }
}

class DeleteSerieResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String timestamp;

  DeleteSerieResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory DeleteSerieResponse.fromJson(Map<String, dynamic> json) {
    try {
      return DeleteSerieResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: json['data'],
        timestamp: (json['timestamp'] as String?) ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw ArgumentError('Invalid DeleteSerieResponse JSON: $e');
    }
  }
}
