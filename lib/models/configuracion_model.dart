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
  }) : assert(configuracionId > 0, 'ConfiguracionId must be positive'),
       assert(_isValidHexColor(primario), 'Primary color must be valid hex'),
       assert(
         _isValidHexColor(secundario),
         'Secondary color must be valid hex',
       ),
       assert(_isValidHexColor(acento1), 'Accent1 color must be valid hex'),
       assert(_isValidHexColor(acento2), 'Accent2 color must be valid hex');

  static bool _isValidHexColor(String color) {
    final cleanColor = color.replaceAll('#', '');
    return RegExp(r'^[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$').hasMatch(cleanColor);
  }

  factory Configuracion.fromJson(Map<String, dynamic> json) {
    try {
      final configuracionId = json['configuracionId'] as int?;
      final primario = json['primario'] as String?;
      final secundario = json['secundario'] as String?;
      final acento1 = json['acento1'] as String?;
      final acento2 = json['acento2'] as String?;

      if (configuracionId == null || configuracionId <= 0) {
        throw ArgumentError(
          'Invalid configuracion: configuracionId must be a positive integer',
        );
      }
      if (primario == null || primario.isEmpty) {
        throw ArgumentError(
          'Invalid configuracion: primario cannot be null or empty',
        );
      }
      if (secundario == null || secundario.isEmpty) {
        throw ArgumentError(
          'Invalid configuracion: secundario cannot be null or empty',
        );
      }
      if (acento1 == null || acento1.isEmpty) {
        throw ArgumentError(
          'Invalid configuracion: acento1 cannot be null or empty',
        );
      }
      if (acento2 == null || acento2.isEmpty) {
        throw ArgumentError(
          'Invalid configuracion: acento2 cannot be null or empty',
        );
      }

      return Configuracion(
        configuracionId: configuracionId,
        primario: primario,
        secundario: secundario,
        acento1: acento1,
        acento2: acento2,
      );
    } catch (e) {
      throw ArgumentError('Invalid Configuracion JSON: $e');
    }
  }

  @override
  String toString() =>
      'Configuracion(id: $configuracionId, primary: $primario, secondary: $secundario)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Configuracion &&
          runtimeType == other.runtimeType &&
          configuracionId == other.configuracionId;

  @override
  int get hashCode => configuracionId.hashCode;
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
    try {
      return ConfiguracionResponse(
        success: (json['success'] as bool?) ?? false,
        message: (json['message'] as String?) ?? 'No message',
        data: Configuracion.fromJson(json['data'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw ArgumentError('Invalid ConfiguracionResponse JSON: $e');
    }
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
