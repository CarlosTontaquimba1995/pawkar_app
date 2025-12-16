class Sancion {
  final int sancionId;
  final String tipoSancion;
  final String motivo;
  final String detalleSancion;
  final String fechaRegistro;

  Sancion({
    required this.sancionId,
    required this.tipoSancion,
    required this.motivo,
    required this.detalleSancion,
    required this.fechaRegistro,
  });

  factory Sancion.fromJson(Map<String, dynamic> json) {
    return Sancion(
      sancionId: json['sancionId'] as int,
      tipoSancion: json['tipoSancion'] as String,
      motivo: json['motivo'] as String? ?? '',
      detalleSancion: json['detalleSancion'] as String? ?? '',
      fechaRegistro: json['fechaRegistro'] as String? ?? '', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sancionId': sancionId,
      'tipoSancion': tipoSancion,
      'motivo': motivo,
      'detalleSancion': detalleSancion,
      'fechaRegistro': fechaRegistro,
    };
  }
}

class Plantilla {
  final int equipoId;
  final String equipoNombre;
  final int jugadorId;
  final String jugadorNombreCompleto;
  final int numeroCamiseta;
  final int rolId;
  final String rolNombre;
  final bool tieneSancion;
  final List<Sancion> sanciones;

  Plantilla({
    required this.equipoId,
    required this.equipoNombre,
    required this.jugadorId,
    required this.jugadorNombreCompleto,
    required this.numeroCamiseta,
    required this.rolId,
    required this.rolNombre,
    required this.tieneSancion,
    required this.sanciones,
  });

  factory Plantilla.fromJson(Map<String, dynamic> json) {
    return Plantilla(
      equipoId: json['equipoId'] as int,
      equipoNombre: json['equipoNombre'] as String,
      jugadorId: json['jugadorId'] as int,
      jugadorNombreCompleto: json['jugadorNombreCompleto'] as String,
      numeroCamiseta: json['numeroCamiseta'] as int,
      rolId: json['rolId'] as int,
      rolNombre: json['rolNombre'] as String,
      tieneSancion: json['tieneSancion'] as bool,
      sanciones: (json['sanciones'] as List<dynamic>?)
              ?.map((e) => Sancion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipoId': equipoId,
      'equipoNombre': equipoNombre,
      'jugadorId': jugadorId,
      'jugadorNombreCompleto': jugadorNombreCompleto,
      'numeroCamiseta': numeroCamiseta,
      'rolId': rolId,
      'rolNombre': rolNombre,
      'tieneSancion': tieneSancion,
      'sanciones': sanciones.map((e) => e.toJson()).toList(),
    };
  }
}

class CreatePlantillaRequest {
  final int equipoId;
  final int jugadorId;
  final int numeroCamiseta;
  final int rolId;

  CreatePlantillaRequest({
    required this.equipoId,
    required this.jugadorId,
    required this.numeroCamiseta,
    required this.rolId,
  });

  Map<String, dynamic> toJson() {
    return {
      'equipoId': equipoId,
      'jugadorId': jugadorId,
      'numeroCamiseta': numeroCamiseta,
      'rolId': rolId,
    };
  }
}

class CreateMultiplePlantillasRequest {
  final List<CreatePlantillaRequest> jugadores;

  CreateMultiplePlantillasRequest({required this.jugadores});

  Map<String, dynamic> toJson() {
    return {
      'jugadores': jugadores.map((e) => e.toJson()).toList(),
    };
  }
}

class PlantillaResponse {
  final bool success;
  final String message;
  final Plantilla data;

  PlantillaResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PlantillaResponse.fromJson(Map<String, dynamic> json) {
    return PlantillaResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: Plantilla.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class PlantillaListResponse {
  final bool success;
  final String message;
  final List<Plantilla> data;

  PlantillaListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PlantillaListResponse.fromJson(Map<String, dynamic> json) {
    return PlantillaListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Plantilla.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DeletePlantillaResponse {
  final bool success;
  final String message;

  DeletePlantillaResponse({
    required this.success,
    required this.message,
  });

  factory DeletePlantillaResponse.fromJson(Map<String, dynamic> json) {
    return DeletePlantillaResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }
}
