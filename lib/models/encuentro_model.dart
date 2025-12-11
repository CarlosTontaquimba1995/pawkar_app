// Enumeración para los estados de un encuentro
enum EstadoEncuentro {
  programado('PROGRAMADO'),
  enJuego('EN_JUEGO'),
  finalizado('FINALIZADO'),
  suspendido('SUSPENDIDO'),
  cancelado('CANCELADO');

  final String value;
  const EstadoEncuentro(this.value);

  static EstadoEncuentro fromString(String value) {
    return EstadoEncuentro.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EstadoEncuentro.programado,
    );
  }
}

class Encuentro {
  final int? id;
  final int subcategoriaId;
  final String subcategoriaNombre;
  final String titulo;
  final String fechaHora;
  final String estadioNombre;
  final int estadioId;
  final EstadoEncuentro estado;
  final bool activo;
  final int equipoLocalId;
  final String equipoLocalNombre;
  final int equipoVisitanteId;
  final String equipoVisitanteNombre;

  Encuentro({
    this.id,
    required this.subcategoriaId,
    required this.subcategoriaNombre,
    required this.titulo,
    required this.fechaHora,
    required this.estadioNombre,
    required this.estadioId,
    required this.estado,
    required this.activo,
    required this.equipoLocalId,
    required this.equipoLocalNombre,
    required this.equipoVisitanteId,
    required this.equipoVisitanteNombre,
  });

  factory Encuentro.fromJson(Map<String, dynamic> json) {
    return Encuentro(
      id: json['id'] as int?,
      subcategoriaId: json['subcategoriaId'] as int,
      subcategoriaNombre: json['subcategoriaNombre'] as String,
      titulo: json['titulo'] as String,
      fechaHora: json['fechaHora'] as String,
      estadioNombre: json['estadioNombre'] as String,
      estadioId: json['estadioId'] as int,
      estado: EstadoEncuentro.fromString(json['estado'] as String),
      activo: json['activo'] as bool,
      equipoLocalId: json['equipoLocalId'] as int,
      equipoLocalNombre: json['equipoLocalNombre'] as String,
      equipoVisitanteId: json['equipoVisitanteId'] as int,
      equipoVisitanteNombre: json['equipoVisitanteNombre'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subcategoriaId': subcategoriaId,
      'subcategoriaNombre': subcategoriaNombre,
      'titulo': titulo,
      'fechaHora': fechaHora,
      'estadioNombre': estadioNombre,
      'estadioId': estadioId,
      'estado': estado.value,
      'activo': activo,
      'equipoLocalId': equipoLocalId,
      'equipoLocalNombre': equipoLocalNombre,
      'equipoVisitanteId': equipoVisitanteId,
      'equipoVisitanteNombre': equipoVisitanteNombre,
    };
  }
}

class CreateEncuentroRequest {
  final int equipoLocalId;
  final int equipoVisitanteId;
  final String fecha;
  final String hora;
  final int estadioId;

  CreateEncuentroRequest({
    required this.equipoLocalId,
    required this.equipoVisitanteId,
    required this.fecha,
    required this.hora,
    required this.estadioId,
  });

  Map<String, dynamic> toJson() => {
    'equipoLocalId': equipoLocalId,
    'equipoVisitanteId': equipoVisitanteId,
    'fecha': fecha,
    'hora': hora,
    'estadioId': estadioId,
  };
}

class CreateMultipleEncuentrosRequest {
  final int subcategoriaId;
  final String tipoGeneracion;
  final List<CreateEncuentroRequest> encuentrosManuales;

  CreateMultipleEncuentrosRequest({
    required this.subcategoriaId,
    required this.tipoGeneracion,
    required this.encuentrosManuales,
  });

  Map<String, dynamic> toJson() => {
    'subcategoriaId': subcategoriaId,
    'tipoGeneracion': tipoGeneracion,
    'encuentrosManuales': encuentrosManuales.map((e) => e.toJson()).toList(),
  };
}

class UpdateEncuentroRequest {
  final String? fechaHora;
  final int? estadioId;
  final EstadoEncuentro? estado;
  final int? subcategoriaId;
  final int? equipoLocalId;
  final int? equipoVisitanteId;

  UpdateEncuentroRequest({
    this.fechaHora,
    this.estadioId,
    this.estado,
    this.subcategoriaId,
    this.equipoLocalId,
    this.equipoVisitanteId,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (fechaHora != null) json['fechaHora'] = fechaHora;
    if (estadioId != null) json['estadioId'] = estadioId;
    if (estado != null) json['estado'] = estado!.value;
    if (subcategoriaId != null) json['subcategoriaId'] = subcategoriaId;
    if (equipoLocalId != null) json['equipoLocalId'] = equipoLocalId;
    if (equipoVisitanteId != null) {
      json['equipoVisitanteId'] = equipoVisitanteId;
    }
    return json;
  }
}

class EncuentroResponse {
  final bool success;
  final String message;
  final Encuentro data;

  EncuentroResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EncuentroResponse.fromJson(Map<String, dynamic> json) {
    return EncuentroResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: Encuentro.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class EncuentroListResponse {
  final bool success;
  final String message;
  final List<Encuentro> data;
  final String timestamp;

  EncuentroListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory EncuentroListResponse.fromJson(Map<String, dynamic> json) {
    return EncuentroListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => Encuentro.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] as String,
    );
  }
}

class DeleteEncuentroResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String timestamp;

  DeleteEncuentroResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory DeleteEncuentroResponse.fromJson(Map<String, dynamic> json) {
    return DeleteEncuentroResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'],
      timestamp: json['timestamp'] as String,
    );
  }
}

class EncuentroPageResponse {
  final bool success;
  final String message;
  final EncuentroPageData data;
  final String timestamp;

  EncuentroPageResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory EncuentroPageResponse.fromJson(Map<String, dynamic> json) {
    return EncuentroPageResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: EncuentroPageData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );
  }
}

class EncuentroPageData {
  final List<Encuentro> content;
  final Pageable pageable;
  final int totalElements;
  final int totalPages;
  final bool last;
  final bool first;
  final Sort sort;
  final int numberOfElements;
  final int size;
  final int number;
  final bool empty;

  EncuentroPageData({
    required this.content,
    required this.pageable,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.first,
    required this.sort,
    required this.numberOfElements,
    required this.size,
    required this.number,
    required this.empty,
  });

  factory EncuentroPageData.fromJson(Map<String, dynamic> json) {
    return EncuentroPageData(
      content: (json['content'] as List)
          .map((e) => Encuentro.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageable: Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      last: json['last'] as bool,
      first: json['first'] as bool,
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      numberOfElements: json['numberOfElements'] as int,
      size: json['size'] as int,
      number: json['number'] as int,
      empty: json['empty'] as bool,
    );
  }
}

class Pageable {
  final Sort sort;
  final int pageNumber;
  final int pageSize;
  final int offset;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.sort,
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      offset: json['offset'] as int,
      paged: json['paged'] as bool,
      unpaged: json['unpaged'] as bool,
    );
  }
}

class Sort {
  final bool sorted;
  final bool unsorted;
  final bool empty;

  Sort({required this.sorted, required this.unsorted, required this.empty});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      sorted: json['sorted'] as bool,
      unsorted: json['unsorted'] as bool,
      empty: json['empty'] as bool,
    );
  }
}

class EncuentroSearchParams {
  final String? titulo;
  final String? fechaInicio;
  final String? fechaFin;
  final int? subcategoriaId;
  final int? equipoId;
  final String? estadioLugar;
  final String? estado;
  final int? page;
  final int? size;

  EncuentroSearchParams({
    this.titulo,
    this.fechaInicio,
    this.fechaFin,
    this.subcategoriaId,
    this.equipoId,
    this.estadioLugar,
    this.estado,
    this.page,
    this.size,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (titulo != null) json['titulo'] = titulo;
    if (fechaInicio != null) json['fechaInicio'] = fechaInicio;
    if (fechaFin != null) json['fechaFin'] = fechaFin;
    if (subcategoriaId != null) json['subcategoriaId'] = subcategoriaId;
    if (equipoId != null) json['equipoId'] = equipoId;
    if (estadioLugar != null) json['estadioLugar'] = estadioLugar;
    if (estado != null) json['estado'] = estado;
    if (page != null) json['page'] = page;
    if (size != null) json['size'] = size;
    return json;
  }
}
