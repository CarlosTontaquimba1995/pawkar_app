class Jugador {
  final int? id;
  final String nombre;
  final String apellido;
  final String fechaNacimiento;
  final String documentoIdentidad;
  final String nombreEquipo;
  final String nombreRol;
  final int? subcategoriaId;
  final int? equipoId;
  final int? numeroCamiseta;
  final int? rolId;

  Jugador({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.documentoIdentidad,
    required this.nombreEquipo,
    required this.nombreRol,
    this.subcategoriaId,
    this.equipoId,
    this.numeroCamiseta,
    this.rolId,
  });

  factory Jugador.fromJson(Map<String, dynamic> json) {
    return Jugador(
      id: json['id'] as int?,
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      fechaNacimiento: json['fechaNacimiento']?.toString() ?? '',
      documentoIdentidad: json['documentoIdentidad']?.toString() ?? '',
      nombreEquipo: json['nombreEquipo']?.toString() ?? '',
      nombreRol: json['nombreRol']?.toString() ?? '',
      subcategoriaId: json['subcategoriaId'] as int?,
      equipoId: json['equipoId'] as int?,
      numeroCamiseta: json['numeroCamiseta'] as int?,
      rolId: json['rolId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'fechaNacimiento': fechaNacimiento,
      'documentoIdentidad': documentoIdentidad,
      'nombreEquipo': nombreEquipo,
      'nombreRol': nombreRol,
      'subcategoriaId': subcategoriaId,
      'equipoId': equipoId,
      'numeroCamiseta': numeroCamiseta,
      'rolId': rolId,
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() => 'Jugador(id: $id, nombre: $nombre $apellido)';
}

class JugadorResponse {
  final bool success;
  final String message;
  final Jugador data;
  final String timestamp;

  JugadorResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory JugadorResponse.fromJson(Map<String, dynamic> json) {
    return JugadorResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: Jugador.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );
  }
}

class JugadorListResponse {
  final bool success;
  final String message;
  final List<Jugador> content;
  final int totalPages;
  final int totalElements;
  final int size;
  final int number;
  final String timestamp;

  JugadorListResponse({
    required this.success,
    required this.message,
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.number,
    required this.timestamp,
  });

  factory JugadorListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return JugadorListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      content: (data['content'] as List<dynamic>)
          .map((e) => Jugador.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: data['totalPages'] as int,
      totalElements: data['totalElements'] as int,
      size: data['size'] as int,
      number: data['number'] as int,
      timestamp: json['timestamp'] as String,
    );
  }
}

class JugadorCountResponse {
  final bool success;
  final String message;
  final int totalJugadores;
  final String timestamp;

  JugadorCountResponse({
    required this.success,
    required this.message,
    required this.totalJugadores,
    required this.timestamp,
  });

  factory JugadorCountResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return JugadorCountResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      totalJugadores: data['totalJugadores'] as int,
      timestamp: json['timestamp'] as String,
    );
  }
}

class CreateJugadorRequest {
  final String nombre;
  final String apellido;
  final String fechaNacimiento;
  final String documentoIdentidad;
  final bool activo;

  CreateJugadorRequest({
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.documentoIdentidad,
    this.activo = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'fechaNacimiento': fechaNacimiento,
      'documentoIdentidad': documentoIdentidad,
      'activo': activo,
    };
  }
}

class UpdateJugadorRequest {
  final String? nombre;
  final String? apellido;
  final String? fechaNacimiento;
  final String? documentoIdentidad;
  final bool? activo;

  UpdateJugadorRequest({
    this.nombre,
    this.apellido,
    this.fechaNacimiento,
    this.documentoIdentidad,
    this.activo,
  });

  Map<String, dynamic> toJson() {
    return {
      if (nombre != null) 'nombre': nombre,
      if (apellido != null) 'apellido': apellido,
      if (fechaNacimiento != null) 'fechaNacimiento': fechaNacimiento,
      if (documentoIdentidad != null) 'documentoIdentidad': documentoIdentidad,
      if (activo != null) 'activo': activo,
    };
  }
}

class CreateMultipleJugadoresRequest {
  final List<CreateJugadorRequest> jugadores;

  CreateMultipleJugadoresRequest({required this.jugadores});

  Map<String, dynamic> toJson() {
    return {
      'jugadores': jugadores.map((e) => e.toJson()).toList(),
    };
  }
}

class JugadorQueryParams {
  final int? page;
  final int? size;
  final String? sort;
  final String? search;

  JugadorQueryParams({
    this.page,
    this.size,
    this.sort,
    this.search,
  });

  Map<String, dynamic> toJson() {
    return {
      if (page != null) 'page': page,
      if (size != null) 'size': size,
      if (sort != null) 'sort': sort,
      if (search != null) 'search': search,
    }..removeWhere((key, value) => value == null);
  }

  String toQueryString() {
    final params = toJson();
    if (params.isEmpty) return '';
    
    final query = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
        
    return '?$query';
  }
}
