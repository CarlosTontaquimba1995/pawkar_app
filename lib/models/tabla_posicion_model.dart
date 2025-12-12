class TablaPosicion {
  final int subcategoriaId;
  final int equipoId;
  final String equipoNombre;
  final int partidosJugados;
  final int victorias;
  final int derrotas;
  final int empates;
  final int puntos;
  final int golesAFavor;
  final int golesEnContra;
  final int diferenciaGoles;
  final int posicion;
  final int serieId;
  final String serieNombre;
  final int categoriaId;
  final String categoriaNombre;

  TablaPosicion({
    required this.subcategoriaId,
    required this.equipoId,
    required this.equipoNombre,
    required this.partidosJugados,
    required this.victorias,
    required this.derrotas,
    required this.empates,
    required this.puntos,
    required this.golesAFavor,
    required this.golesEnContra,
    required this.diferenciaGoles,
    required this.posicion,
    required this.serieId,
    required this.serieNombre,
    required this.categoriaId,
    required this.categoriaNombre,
  });

  factory TablaPosicion.fromJson(Map<String, dynamic> json) {
    return TablaPosicion(
      subcategoriaId: json['subcategoriaId'] as int,
      equipoId: json['equipoId'] as int,
      equipoNombre: json['equipoNombre'] as String,
      partidosJugados: json['partidosJugados'] as int,
      victorias: json['victorias'] as int,
      derrotas: json['derrotas'] as int,
      empates: json['empates'] as int,
      puntos: json['puntos'] as int,
      golesAFavor: json['golesAFavor'] as int,
      golesEnContra: json['golesEnContra'] as int,
      diferenciaGoles: json['diferenciaGoles'] as int,
      posicion: json['posicion'] as int,
      serieId: json['serieId'] as int,
      serieNombre: json['serieNombre'] as String,
      categoriaId: json['categoriaId'] as int,
      categoriaNombre: json['categoriaNombre'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subcategoriaId': subcategoriaId,
      'equipoId': equipoId,
      'equipoNombre': equipoNombre,
      'partidosJugados': partidosJugados,
      'victorias': victorias,
      'derrotas': derrotas,
      'empates': empates,
      'puntos': puntos,
      'golesAFavor': golesAFavor,
      'golesEnContra': golesEnContra,
      'diferenciaGoles': diferenciaGoles,
      'posicion': posicion,
      'serieId': serieId,
      'serieNombre': serieNombre,
      'categoriaId': categoriaId,
      'categoriaNombre': categoriaNombre,
    };
  }
}

class TablaPosicionRequest {
  final int subcategoriaId;
  final int equipoId;
  final int partidosJugados;
  final int victorias;
  final int derrotas;
  final int empates;
  final int puntos;
  final int golesAFavor;
  final int golesEnContra;
  final int diferenciaGoles;

  TablaPosicionRequest({
    required this.subcategoriaId,
    required this.equipoId,
    required this.partidosJugados,
    required this.victorias,
    required this.derrotas,
    required this.empates,
    required this.puntos,
    required this.golesAFavor,
    required this.golesEnContra,
    required this.diferenciaGoles,
  });

  Map<String, dynamic> toJson() {
    return {
      'subcategoriaId': subcategoriaId,
      'equipoId': equipoId,
      'partidosJugados': partidosJugados,
      'victorias': victorias,
      'derrotas': derrotas,
      'empates': empates,
      'puntos': puntos,
      'golesAFavor': golesAFavor,
      'golesEnContra': golesEnContra,
      'diferenciaGoles': diferenciaGoles,
    };
  }
}

class TablaPosicionResponse {
  final bool success;
  final String message;
  final List<TablaPosicion> data;
  final String timestamp;

  TablaPosicionResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory TablaPosicionResponse.fromJson(Map<String, dynamic> json) {
    return TablaPosicionResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => TablaPosicion.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] as String,
    );
  }
}

class ActualizarDesdePartidoRequest {
  final int subcategoriaId;
  final int equipoLocalId;
  final int equipoVisitanteId;
  final int golesLocal;
  final int golesVisitante;
  final String estadoPartido;

  ActualizarDesdePartidoRequest({
    required this.subcategoriaId,
    required this.equipoLocalId,
    required this.equipoVisitanteId,
    required this.golesLocal,
    required this.golesVisitante,
    required this.estadoPartido,
  });

  Map<String, dynamic> toJson() {
    return {
      'subcategoriaId': subcategoriaId,
      'equipoLocalId': equipoLocalId,
      'equipoVisitanteId': equipoVisitanteId,
      'golesLocal': golesLocal,
      'golesVisitante': golesVisitante,
      'estadoPartido': estadoPartido,
    };
  }
}

class EquipoPosicion {
  final int tablaPosicionId;
  final int subcategoriaId;
  final int equipoId;
  final String nombreEquipo;
  final int partidosJugados;
  final int victorias;
  final int derrotas;
  final int empates;
  final int golesAFavor;
  final int golesEnContra;
  final int diferenciaGoles;
  final int puntos;
  final int posicion;

  EquipoPosicion({
    required this.tablaPosicionId,
    required this.subcategoriaId,
    required this.equipoId,
    required this.nombreEquipo,
    required this.partidosJugados,
    required this.victorias,
    required this.derrotas,
    required this.empates,
    required this.golesAFavor,
    required this.golesEnContra,
    required this.diferenciaGoles,
    required this.puntos,
    required this.posicion,
  });

  factory EquipoPosicion.fromJson(Map<String, dynamic> json) {
    return EquipoPosicion(
      tablaPosicionId: json['tablaPosicionId'] as int,
      subcategoriaId: json['subcategoriaId'] as int,
      equipoId: json['equipoId'] as int,
      nombreEquipo: json['nombreEquipo'] as String,
      partidosJugados: json['partidosJugados'] as int,
      victorias: json['victorias'] as int,
      derrotas: json['derrotas'] as int,
      empates: json['empates'] as int,
      golesAFavor: json['golesAFavor'] as int,
      golesEnContra: json['golesEnContra'] as int,
      diferenciaGoles: json['diferenciaGoles'] as int,
      puntos: json['puntos'] as int,
      posicion: json['posicion'] as int,
    );
  }
}

class EquipoPosicionResponse {
  final bool success;
  final String message;
  final EquipoPosicion data;

  EquipoPosicionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EquipoPosicionResponse.fromJson(Map<String, dynamic> json) {
    return EquipoPosicionResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: EquipoPosicion.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class SearchParams {
  final int? subcategoriaId;
  final int? categoriaId;
  final int? equipoId;
  final int? serieId;
  final String? nombreEquipo;
  final int? page;
  final int? size;
  final String? sort;

  SearchParams({
    this.subcategoriaId,
    this.categoriaId,
    this.equipoId,
    this.serieId,
    this.nombreEquipo,
    this.page,
    this.size,
    this.sort,
  });

  Map<String, dynamic> toJson() {
    return {
      if (subcategoriaId != null) 'subcategoriaId': subcategoriaId,
      if (categoriaId != null) 'categoriaId': categoriaId,
      if (equipoId != null) 'equipoId': equipoId,
      if (serieId != null) 'serieId': serieId,
      if (nombreEquipo != null) 'nombreEquipo': nombreEquipo,
      if (page != null) 'page': page,
      if (size != null) 'size': size,
      if (sort != null) 'sort': sort,
    }..removeWhere((key, value) => value == null);
  }
}
