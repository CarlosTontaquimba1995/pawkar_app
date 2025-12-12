import 'package:flutter/material.dart';
import 'package:pawkar_app/models/subcategoria_model.dart';
import 'package:pawkar_app/services/categoria_service.dart';
import 'package:pawkar_app/services/subcategoria_service.dart';

class EventosDestacadosSection extends StatefulWidget {
  const EventosDestacadosSection({super.key});

  @override
  EventosDestacadosSectionState createState() =>
      EventosDestacadosSectionState();
}

class EventosDestacadosSectionState extends State<EventosDestacadosSection> {
  late final Future<List<Subcategoria>> _eventosDestacadosFuture;
  final CategoriaService _categoriaService = CategoriaService();
  final SubcategoriaService _subcategoriaService = SubcategoriaService();

  @override
  void initState() {
    super.initState();
    _eventosDestacadosFuture = _loadEventosDestacados();
  }

  Future<List<Subcategoria>> _loadEventosDestacados() async {
    try {
      final categoriaDeportes = await _categoriaService.getCategoriaByNemonico(
        'DEPORTES',
      );
      return await _subcategoriaService.getSubcategoriasByCategoria(
        categoriaDeportes.categoriaId,
      );
    } catch (e) {
      debugPrint('Error loading featured events: $e');
      return []; // Return empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Subcategoria>>(
      future: _eventosDestacadosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay eventos destacados'));
        }

        final eventos = snapshot.data!;
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              return _buildEventoItem(eventos[index]);
            },
          ),
        );
      },
    );
  }

  // Map event types to their corresponding image paths
  String _getImageForEvent(String eventName) {
    final lowerName = eventName.toLowerCase();
    if (lowerName.contains('futbol') || lowerName.contains('fútbol')) {
      return 'assets/images/futbol.jpg';
    } else if (lowerName.contains('basket') ||
        lowerName.contains('básket') ||
        lowerName.contains('baloncesto')) {
      return 'assets/images/basket.jpg';
    } else if (lowerName.contains('voley') || lowerName.contains('voleibol')) {
      return 'assets/images/voley.jpg';
    } else if (lowerName.contains('gastronomía') ||
        lowerName.contains('gastronomia')) {
      return 'assets/images/gastronomia.jpg';
    }
    // Default image if no match is found
    return 'assets/images/splash_logo.png';
  }

  Widget _buildEventoItem(Subcategoria evento) {
    final imagePath = _getImageForEvent(evento.nombre);
    
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section (2/3 of the card)
            Expanded(
              flex: 2,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 100,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // Content section (1/3 of the card)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (evento.descripcion.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        evento.descripcion,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
