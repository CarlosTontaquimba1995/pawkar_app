// Model for Artista entity with manual JSON serialization
class Artista {
  final String nombre;
  final String genero;

  Artista({
    required this.nombre,
    required this.genero,
  })  : assert(nombre.isNotEmpty, 'Nombre cannot be empty'),
       assert(genero.isNotEmpty, 'Género cannot be empty');

  factory Artista.fromJson(Map<String, dynamic> json) {
    try {
      final nombre = json['nombre'] as String?;
      final genero = json['genero'] as String?;

      if (nombre == null || nombre.isEmpty) {
        throw ArgumentError('Invalid artista: nombre cannot be null or empty');
      }
      if (genero == null || genero.isEmpty) {
        throw ArgumentError('Invalid artista: genero cannot be null or empty');
      }

      return Artista(
        nombre: nombre,
        genero: genero,
      );
    } catch (e) {
      throw FormatException('Error parsing Artista from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'genero': genero,
    };
  }

  @override
  String toString() => 'Artista(nombre: $nombre, genero: $genero)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Artista && 
           other.nombre == nombre && 
           other.genero == genero;
  }

  @override
  int get hashCode => nombre.hashCode ^ genero.hashCode;
}
