// Base Team model
class Equipo {
  final int equipoId;
  final int subcategoriaId;
  final String subcategoriaNombre;
  final int serieId;
  final String serieNombre;
  final String nombre;
  final String fundacion;
  final int jugadoresCount;
  final String estado;

  Equipo({
    required this.equipoId,
    required this.subcategoriaId,
    required this.subcategoriaNombre,
    required this.serieId,
    required this.serieNombre,
    required this.nombre,
    required this.fundacion,
    required this.jugadoresCount,
    required this.estado,
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      equipoId: json['equipoId'] as int,
      subcategoriaId: json['subcategoriaId'] as int,
      subcategoriaNombre: json['subcategoriaNombre'] as String,
      serieId: json['serieId'] as int,
      serieNombre: json['serieNombre'] as String,
      nombre: json['nombre'] as String,
      fundacion: json['fundacion'] as String,
      jugadoresCount: json['jugadoresCount'] as int,
      estado: json['estado'] as String,
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
}

// Request models
class CreateEquipoRequest {
  final int subcategoriaId;
  final int serieId;
  final String nombre;
  final String? estado;

  CreateEquipoRequest({
    required this.subcategoriaId,
    required this.serieId,
    required this.nombre,
    this.estado = 'activo',
  });

  Map<String, dynamic> toJson() {
    return {
      'subcategoriaId': subcategoriaId,
      'serieId': serieId,
      'nombre': nombre,
      if (estado != null) 'estado': estado,
    };
  }
}

class UpdateEquipoRequest {
  final int? subcategoriaId;
  final int? serieId;
  final String? nombre;
  final String? estado;

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

class CreateMultipleEquiposRequest {
  final List<CreateEquipoRequest> equipos;

  CreateMultipleEquiposRequest({required this.equipos});

  Map<String, dynamic> toJson() {
    return {'equipos': equipos.map((e) => e.toJson()).toList()};
  }
}

// Response models
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
    return EquipoResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: Equipo.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );
  }
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
    return EquipoListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => Equipo.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] as String,
    );
  }
}

class EquipoListPageResponse {
  final bool success;
  final String message;
  final EquipoPageData data;
  final String timestamp;

  EquipoListPageResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory EquipoListPageResponse.fromJson(Map<String, dynamic> json) {
    return EquipoListPageResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: EquipoPageData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );
  }
}

class EquipoPageData {
  final List<Equipo> content;
  final Pageable pageable;
  final int totalElements;
  final int totalPages;
  final bool last;
  final int size;
  final int number;
  final Sort sort;
  final int numberOfElements;
  final bool first;
  final bool empty;

  EquipoPageData({
    required this.content,
    required this.pageable,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  factory EquipoPageData.fromJson(Map<String, dynamic> json) {
    return EquipoPageData(
      content: (json['content'] as List)
          .map((e) => Equipo.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageable: Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      last: json['last'] as bool,
      size: json['size'] as int,
      number: json['number'] as int,
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      numberOfElements: json['numberOfElements'] as int,
      first: json['first'] as bool,
      empty: json['empty'] as bool,
    );
  }
}

class Pageable {
  final int pageNumber;
  final int pageSize;
  final Sort sort;
  final int offset;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.pageNumber,
    required this.pageSize,
    required this.sort,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      offset: json['offset'] as int,
      paged: json['paged'] as bool,
      unpaged: json['unpaged'] as bool,
    );
  }
}

class Sort {
  final bool empty;
  final bool sorted;
  final bool unsorted;

  Sort({required this.empty, required this.sorted, required this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      empty: json['empty'] as bool,
      sorted: json['sorted'] as bool,
      unsorted: json['unsorted'] as bool,
    );
  }
}

class EquipoCountResponse {
  final bool success;
  final String message;
  final EquipoCountData data;
  final String timestamp;

  EquipoCountResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory EquipoCountResponse.fromJson(Map<String, dynamic> json) {
    return EquipoCountResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: EquipoCountData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );
  }
}

class EquipoCountData {
  final int totalEquipos;
  final int equiposActivos;
  final int equiposInactivos;

  EquipoCountData({
    required this.totalEquipos,
    required this.equiposActivos,
    required this.equiposInactivos,
  });

  factory EquipoCountData.fromJson(Map<String, dynamic> json) {
    return EquipoCountData(
      totalEquipos: json['totalEquipos'] as int,
      equiposActivos: json['equiposActivos'] as int,
      equiposInactivos: json['equiposInactivos'] as int,
    );
  }
}

// Query parameter models
class EquipoQueryParams {
  final int? page;
  final int? size;
  final String? sort;
  final String? nombre;
  final String? search;

  EquipoQueryParams({
    this.page,
    this.size,
    this.sort,
    this.nombre,
    this.search,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (page != null) json['page'] = page;
    if (size != null) json['size'] = size;
    if (sort != null) json['sort'] = sort;
    if (nombre != null) json['nombre'] = nombre;
    if (search != null) json['search'] = search;
    return json;
  }
}

class EquipoBySubcategoryParams extends EquipoQueryParams {
  final int? serieId;

  EquipoBySubcategoryParams({
    this.serieId,
    int? page,
    int? size,
    String? sort,
    String? nombre,
    String? search,
  }) : super(
         page: page,
         size: size,
         sort: sort,
         nombre: nombre,
         search: search,
       );

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    if (serieId != null) json['serieId'] = serieId;
    return json;
  }
}
