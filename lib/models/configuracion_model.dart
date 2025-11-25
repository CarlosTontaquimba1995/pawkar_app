class Configuracion {
  final int configuracionId;
  final String primario;
  final String secundario;
  final String acento1;
  final String acento2;

  Configuracion({
    required this.configuracionId,
    required this.primario,
    required this.secundario,
    required this.acento1,
    required this.acento2,
  });

  factory Configuracion.fromJson(Map<String, dynamic> json) {
    return Configuracion(
      configuracionId: json['configuracionId'] as int,
      primario: json['primario'] as String,
      secundario: json['secundario'] as String,
      acento1: json['acento1'] as String,
      acento2: json['acento2'] as String,
    );
  }
}

class ConfiguracionResponse {
  final bool success;
  final String message;
  final Configuracion data;

  ConfiguracionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConfiguracionResponse.fromJson(Map<String, dynamic> json) {
    return ConfiguracionResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: Configuracion.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class UpdateConfiguracionRequest {
  final String primario;
  final String secundario;
  final String acento1;
  final String acento2;

  UpdateConfiguracionRequest({
    required this.primario,
    required this.secundario,
    required this.acento1,
    required this.acento2,
  });

  Map<String, dynamic> toJson() {
    return {
      'primario': primario,
      'secundario': secundario,
      'acento1': acento1,
      'acento2': acento2,
    };
  }
}
